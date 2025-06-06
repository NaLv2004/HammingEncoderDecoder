from pytv import convert
from pytv import moduleloader
import math

@ convert
def ModuleSyncFrame(hamming_spec):
    #/ module SyncFrame(
    #/     input clk_out,
    #/     input rst,
    #/     input data_in,
    #/     output is_frame_sychronized,
    #/     output [2:0] synchronizer_state,
    #/     output data_sync_out
    #/ );
    # state definitions
    CAPTURE = "3'b000"
    FORWARD_PROTECTION = "3'b001"
    SYNC = "3'b010"
    BACKWARD_PROTECTION = "3'b011"
    #/ wire [2:0] synchronizer_state;
    #/ reg [2:0] sychronizer_state_reg;
    #/ reg [`hamming_spec.backward_correct_frame_cnt_width-1`:0] backward_correct_frame_cnt;
    #/ reg [`hamming_spec.forward_false_frame_cnt_width-1`:0] forward_false_frame_cnt;
    #/ reg [`hamming_spec.frame_head_length-1`:0] frame_head_buffer;
    #/ reg [`hamming_spec.output_counter_len-1`:0] input_bit_counter;
    #/ reg data_sync_out_delayed;
    #/ assign synchronizer_state = sychronizer_state_reg;
    #/ assign is_frame_sychronized = ((sychronizer_state_reg == `SYNC`)||(sychronizer_state_reg == `FORWARD_PROTECTION`))? 1'b1 : 1'b0;
    #/ assign data_sync_out = data_sync_out_delayed; //frame_head_buffer[`hamming_spec.frame_head_length-1`:`hamming_spec.frame_head_length-1`];
    # // sliding window register for detecting frame head  
    #/ always @ (posedge clk_out or posedge rst)
    #/ begin
    #/     if (rst) begin
    #/         data_sync_out_delayed <= 1'b0;
    #/         sychronizer_state_reg <= `CAPTURE`;
    #/         frame_head_buffer <= `hamming_spec.frame_length`'b0;
    #/         // is_frame_sychronized <= 1'b0;
    #/     end else begin
    #/         data_sync_out_delayed <= frame_head_buffer[`hamming_spec.frame_head_length-1`:`hamming_spec.frame_head_length-1`];
    #/         frame_head_buffer[0] <= data_in;
    for i in range(1, hamming_spec.frame_head_length):
        #/         frame_head_buffer[`i`] <= frame_head_buffer[`i-1`];
        pass
    #/     end
    #/ end
    #/ // state transition logic
    #/ always @ (posedge clk_out or posedge rst)
    #/ begin
    #/       if (rst) begin
    #/              sychronizer_state_reg <= `CAPTURE`;
    #/              backward_correct_frame_cnt <= `hamming_spec.backward_correct_frame_cnt_width`'b0;
    #/              forward_false_frame_cnt <= `hamming_spec.forward_false_frame_cnt_width`'b0;
    #/              // is_frame_sychronized <= 1'b0;
    #/              // backward_protection_frame_cnt <= `hamming_spec.forward_false_frame_cnt_width`'b0;
    #/              input_bit_counter <= `hamming_spec.output_counter_len`'b0;
    #/          end
    #/      case (sychronizer_state_reg)
    #/         
    #/          // CAPTURE:
    #/          // if current frame buffer matches the frame head, move to BACKWARD_PROTECTION state and set correct frame counter to 1
    #/          `CAPTURE`:
    #/                  begin
    #/                      if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                          sychronizer_state_reg <= `BACKWARD_PROTECTION`;
    #/                          backward_correct_frame_cnt <= 1;
    #/                      end else begin 
    #/                          sychronizer_state_reg <= `CAPTURE`;
    #/                          input_bit_counter <= 0;
    #/                      end
    #/                  end
    #/          `BACKWARD_PROTECTION`:
    #/                  begin
    #/                        if (input_bit_counter == `hamming_spec.output_counter_len`'d`hamming_spec.frame_length-1`) begin
    #/                            input_bit_counter <= 0;
    #/                            if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                                backward_correct_frame_cnt <= backward_correct_frame_cnt + 1;
    #/                                if (backward_correct_frame_cnt == `hamming_spec.backward_correct_frame_cnt_width`'d`hamming_spec.backward_correct_frame_cnt`) begin
    #/                                     sychronizer_state_reg <= `SYNC`;
    #/                                end else begin
    #/                                     sychronizer_state_reg <= `BACKWARD_PROTECTION`;
    #/                                end
    #/                            end
    #/                            else begin
    #/                                backward_correct_frame_cnt <= 0;
    #/                                sychronizer_state_reg <= `CAPTURE`;
    #/                            end
    #/                        end else begin 
    #/                            input_bit_counter <= input_bit_counter + 1;
    #/                            sychronizer_state_reg <= `BACKWARD_PROTECTION`;
    #/                        end
    #/                  end
    #/          `SYNC`:
    #/                  begin
    #/                       if (input_bit_counter == `hamming_spec.output_counter_len`'d`hamming_spec.frame_length-1`) begin
    #/                            input_bit_counter <= 0;
    #/                            if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                                sychronizer_state_reg <= `SYNC`;
    #/                            end else begin 
    #/                                sychronizer_state_reg <= `FORWARD_PROTECTION`;
    #/                                forward_false_frame_cnt <= 0;
    #/                            end
    #/                       end else begin
    #/                            input_bit_counter <= input_bit_counter + 1;
    #/                            sychronizer_state_reg <= `SYNC`;
    #/                       end
    #/                  end
    #/          `FORWARD_PROTECTION`:
    #/                  begin
    #/                         if (input_bit_counter == `hamming_spec.output_counter_len`'d`hamming_spec.frame_length-1`) begin
    #/                                input_bit_counter <= 0;
    #/                                if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                                    sychronizer_state_reg <= `SYNC`;
    #/                                    forward_false_frame_cnt <= 0;
    #/                                end else begin 
    #/                                    forward_false_frame_cnt <= forward_false_frame_cnt + 1;
    #/                                    if (forward_false_frame_cnt == `hamming_spec.forward_false_frame_cnt_width`'d`hamming_spec.forward_false_frame_cnt`) begin
    #/                                         sychronizer_state_reg <= `CAPTURE`;
    #/                                     end else begin
    #/                                         sychronizer_state_reg <= `FORWARD_PROTECTION`;
    #/                                     end
    #/                                end
    #/                          end else begin
    #/                                input_bit_counter <= input_bit_counter + 1;
    #/                                sychronizer_state_reg <= `FORWARD_PROTECTION`;
    #/                          end
    #/                  end
    #/      endcase
    #/ end
    #/ endmodule
    #/ 
