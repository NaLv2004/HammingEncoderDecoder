 module SyncFrame0000000001 (
     input clk_out,
     input rst,
     input data_in,
     output is_frame_sychronized,
     output [2:0] synchronizer_state,
     output data_sync_out
 );
 wire [2:0] synchronizer_state;
 reg [2:0] sychronizer_state_reg;
 reg [1:0] backward_correct_frame_cnt;
 reg [0:0] forward_false_frame_cnt;
 reg [7:0] frame_head_buffer;
 reg [6:0] input_bit_counter;
 reg data_sync_out_delayed;
 assign synchronizer_state = sychronizer_state_reg;
 assign is_frame_sychronized = ((sychronizer_state_reg == 3'b010)||(sychronizer_state_reg == 3'b001))? 1'b1 : 1'b0;
 assign data_sync_out = data_sync_out_delayed; //frame_head_buffer[7:7];
 always @ (posedge clk_out or posedge rst)
 begin
     if (rst) begin
         data_sync_out_delayed <= 1'b0;
         sychronizer_state_reg <= 3'b000;
         frame_head_buffer <= 64'b0;
         // is_frame_sychronized <= 1'b0;
     end else begin
         data_sync_out_delayed <= frame_head_buffer[7:7];
         frame_head_buffer[0] <= data_in;
         frame_head_buffer[1] <= frame_head_buffer[0];
         frame_head_buffer[2] <= frame_head_buffer[1];
         frame_head_buffer[3] <= frame_head_buffer[2];
         frame_head_buffer[4] <= frame_head_buffer[3];
         frame_head_buffer[5] <= frame_head_buffer[4];
         frame_head_buffer[6] <= frame_head_buffer[5];
         frame_head_buffer[7] <= frame_head_buffer[6];
     end
 end
 // state transition logic
 always @ (posedge clk_out or posedge rst)
 begin
       if (rst) begin
              sychronizer_state_reg <= 3'b000;
              backward_correct_frame_cnt <= 2'b0;
              forward_false_frame_cnt <= 1'b0;
              // is_frame_sychronized <= 1'b0;
              // backward_protection_frame_cnt <= 1'b0;
              input_bit_counter <= 7'b0;
          end
      case (sychronizer_state_reg)

          // CAPTURE:
          // if current frame buffer matches the frame head, move to BACKWARD_PROTECTION state and set correct frame counter to 1
          3'b000:
                  begin
                      if (frame_head_buffer == 8'b01111110) begin
                          sychronizer_state_reg <= 3'b011;
                          backward_correct_frame_cnt <= 1;
                      end else begin
                          sychronizer_state_reg <= 3'b000;
                          input_bit_counter <= 0;
                      end
                  end
          3'b011:
                  begin
                        if (input_bit_counter == 7'd63) begin
                            input_bit_counter <= 0;
                            if (frame_head_buffer == 8'b01111110) begin
                                backward_correct_frame_cnt <= backward_correct_frame_cnt + 1;
                                if (backward_correct_frame_cnt == 2'd1) begin
                                     sychronizer_state_reg <= 3'b010;
                                end else begin
                                     sychronizer_state_reg <= 3'b011;
                                end
                            end
                            else begin
                                backward_correct_frame_cnt <= 0;
                                sychronizer_state_reg <= 3'b000;
                            end
                        end else begin
                            input_bit_counter <= input_bit_counter + 1;
                            sychronizer_state_reg <= 3'b011;
                        end
                  end
          3'b010:
                  begin
                       if (input_bit_counter == 7'd63) begin
                            input_bit_counter <= 0;
                            if (frame_head_buffer == 8'b01111110) begin
                                sychronizer_state_reg <= 3'b010;
                            end else begin
                                sychronizer_state_reg <= 3'b001;
                                forward_false_frame_cnt <= 0;
                            end
                       end else begin
                            input_bit_counter <= input_bit_counter + 1;
                            sychronizer_state_reg <= 3'b010;
                       end
                  end
          3'b001:
                  begin
                         if (input_bit_counter == 7'd63) begin
                                input_bit_counter <= 0;
                                if (frame_head_buffer == 8'b01111110) begin
                                    sychronizer_state_reg <= 3'b010;
                                    forward_false_frame_cnt <= 0;
                                end else begin
                                    forward_false_frame_cnt <= forward_false_frame_cnt + 1;
                                    if (forward_false_frame_cnt == 1'd0) begin
                                         sychronizer_state_reg <= 3'b000;
                                     end else begin
                                         sychronizer_state_reg <= 3'b001;
                                     end
                                end
                          end else begin
                                input_bit_counter <= input_bit_counter + 1;
                                sychronizer_state_reg <= 3'b001;
                          end
                  end
      endcase
 end
 endmodule

