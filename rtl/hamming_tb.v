// === Contents from: Decoder0000000001.v ===
 module Decoder0000000001 (
     input clk_decoder_in,
     input clk_decoder_out,
     input rst,
     input decoder_data_valid,
     input data_decoder_in,
     output data_decoder_out
 );
 reg [63:0] decoder_input_buffer;
 reg [31:0] decoder_output_buffer;
 reg [6:0] decoder_input_counter_reg;
 reg [5:0] decoder_output_counter_reg;
 reg decoder_frame_ready;
 reg decoder_data_out_reg;
 wire [63:0] decoder_input_data_wire;
 wire [31:0] decoder_output_data_wire;
 wire [5:0] decoder_output_read_idx;
 wire [6:0] decoder_input_write_idx;
 assign decoder_input_data_wire = decoder_input_buffer;
 // assign decoder_output_data_wire = decoder_output_buffer;
 assign decoder_output_read_idx =6'd 31-decoder_output_counter_reg;
 assign decoder_input_write_idx =7'd 63-decoder_input_counter_reg;
 assign data_decoder_out = decoder_data_out_reg;//decoder_output_buffer[decoder_output_read_idx];
 // decoding the input data (instantiate 8 single decoders)
SingleDecoder0000000001  u_0000000001_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[6:0]), .decoder_out(decoder_output_data_wire[3:0]));
SingleDecoder0000000001  u_0000000002_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[13:7]), .decoder_out(decoder_output_data_wire[7:4]));
SingleDecoder0000000001  u_0000000003_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[20:14]), .decoder_out(decoder_output_data_wire[11:8]));
SingleDecoder0000000001  u_0000000004_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[27:21]), .decoder_out(decoder_output_data_wire[15:12]));
SingleDecoder0000000001  u_0000000005_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[34:28]), .decoder_out(decoder_output_data_wire[19:16]));
SingleDecoder0000000001  u_0000000006_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[41:35]), .decoder_out(decoder_output_data_wire[23:20]));
SingleDecoder0000000001  u_0000000007_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[48:42]), .decoder_out(decoder_output_data_wire[27:24]));
SingleDecoder0000000001  u_0000000008_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire[55:49]), .decoder_out(decoder_output_data_wire[31:28]));
 always @(posedge clk_decoder_in or posedge rst)
 begin
     if (rst) begin
         decoder_input_buffer <= 7'b0;
         decoder_output_buffer <= 32'b0;
         decoder_input_counter_reg <= 0;
         decoder_output_counter_reg <= 0;
         decoder_frame_ready <= 1'b0;
         decoder_data_out_reg <= 1'b0;
     end else begin
         if (decoder_data_valid) begin
             decoder_input_buffer[decoder_input_write_idx] <= data_decoder_in;
             decoder_input_counter_reg <= decoder_input_counter_reg + 1;
             if (decoder_input_counter_reg == 63) begin
                  decoder_input_counter_reg <= 0;
                  decoder_frame_ready <= 1'b1;
                  decoder_output_buffer <= decoder_output_data_wire;
             end
         end
     end
 end
 always @(posedge clk_decoder_out or posedge rst)
 begin
     if (decoder_frame_ready) begin
         decoder_data_out_reg <= decoder_output_buffer[decoder_output_read_idx];
         decoder_output_counter_reg <= decoder_output_counter_reg + 1;
     end
     if (decoder_output_counter_reg == 31) begin
         decoder_output_counter_reg <= 0;
     end
 end
 endmodule


// === Contents from: HammingEncoder0000000001.v ===
 module HammingEncoder0000000001 (
     input clk_in,
     input clk_out,
     input rst,
     input data_in,
     input data_valid,
     output data_out,
     output data_in_ready,
     output data_out_error
 );
 wire clk_in;
 wire clk_out;
 wire rst;
 wire data_in;
 wire data_valid;
 wire data_out;
 wire data_in_ready;
 wire frame_ready_wire;
 reg input_bit_reg;
 reg [63:0] tx_frame_buffer;
 reg [31:0] input_data_buffer;
 reg [5:0] input_counter_reg;
 reg [6:0] output_counter_reg;
 reg [5:0] input_counter_reg_prev;
 reg [5:0] input_counter_reg_delayed_clkout_1;
 reg [5:0] input_counter_reg_delayed_clkout_2;
 reg [5:0] input_counter_reg_delayed_clkout_3;
 wire [5:0] input_write_idx;
 wire [6:0] output_read_idx;
 wire [63:0] tx_frame_wire;
 wire [31:0] input_data_wire;
 reg [8:0] n_frames_sent;
 reg frame_ready;
 reg encoder_ready;
 reg data_buffer_ready;
 reg data_out_reg;
 assign data_out = data_out_reg;
 assign data_in_ready = data_buffer_ready;
 // the higher bits are transmitted first
 assign input_data_wire = input_data_buffer;
 assign frame_ready_wire = ((input_counter_reg_delayed_clkout_1 == 31) && (input_counter_reg==0))? 1 : 0;
 assign input_write_idx =6'd 31-input_counter_reg;
 assign output_read_idx =7'd 63-output_counter_reg;
 assign data_out_error =
     (output_read_idx == 7'd 54) ? (~data_out) :
     (output_read_idx == 7'd 45) ? (~data_out) :
     (output_read_idx == 7'd 36) ? (~data_out) :
     (output_read_idx == 7'd 27) ? (~data_out) :
     data_out;
 // frame head for synchronization
 assign tx_frame_wire[63:56] =
     8'b01111110;
 // assign encoding input to data input buffer,  assign tx_frame_wire to encoding output
 // instantiate single encoder for each group of data
SingleEncoder0000000001  u_0000000001_SingleEncoder0000000001(.data_in(input_data_wire[3:0]), .data_out(tx_frame_wire[6:0]));
SingleEncoder0000000001  u_0000000002_SingleEncoder0000000001(.data_in(input_data_wire[7:4]), .data_out(tx_frame_wire[13:7]));
SingleEncoder0000000001  u_0000000003_SingleEncoder0000000001(.data_in(input_data_wire[11:8]), .data_out(tx_frame_wire[20:14]));
SingleEncoder0000000001  u_0000000004_SingleEncoder0000000001(.data_in(input_data_wire[15:12]), .data_out(tx_frame_wire[27:21]));
SingleEncoder0000000001  u_0000000005_SingleEncoder0000000001(.data_in(input_data_wire[19:16]), .data_out(tx_frame_wire[34:28]));
SingleEncoder0000000001  u_0000000006_SingleEncoder0000000001(.data_in(input_data_wire[23:20]), .data_out(tx_frame_wire[41:35]));
SingleEncoder0000000001  u_0000000007_SingleEncoder0000000001(.data_in(input_data_wire[27:24]), .data_out(tx_frame_wire[48:42]));
SingleEncoder0000000001  u_0000000008_SingleEncoder0000000001(.data_in(input_data_wire[31:28]), .data_out(tx_frame_wire[55:49]));
 always @ (posedge clk_in or posedge rst)
 begin
 input_counter_reg_prev <= input_counter_reg;
     if (rst) begin
         tx_frame_buffer <= 64'b0;
         input_data_buffer <= 32'b0;
         input_counter_reg <= 6'b0;
         output_counter_reg <= 7'b0;
         input_bit_reg <= 1'b0;
         frame_ready <= 0;
         data_out_reg <= 0;
         encoder_ready <= 1'b1;
         data_buffer_ready <= 1'b1;
         n_frames_sent <= 0;
     end  else begin
         if (data_valid ) begin
             input_data_buffer[input_write_idx] <= data_in;
             input_counter_reg <= input_counter_reg + 1;
             data_buffer_ready <= 1'b0;
             input_bit_reg <= data_in;
          end
         if (input_counter_reg == 31) begin // input_counter_reg_prev == 31
             // frame_ready <= 1'b1;
             input_counter_reg <= 0;
             data_buffer_ready <= 1'b1;
             encoder_ready <= 1'b0;
         end
     end
 end
 // output data with twice the rate of input data
 always @ (posedge clk_out or posedge rst)
 begin
     input_counter_reg_delayed_clkout_1 <= input_counter_reg;
     input_counter_reg_delayed_clkout_2 <= input_counter_reg_delayed_clkout_1;
     input_counter_reg_delayed_clkout_3 <= input_counter_reg_delayed_clkout_2;
     if (frame_ready_wire) begin
          frame_ready <= 1'b1;
             tx_frame_buffer <= tx_frame_wire;
          n_frames_sent <= n_frames_sent + 1;
     end
     if (frame_ready) begin
         output_counter_reg <= output_counter_reg + 1;
         data_out_reg <= tx_frame_buffer[output_read_idx];

        // encoder_ready <= 1'b0;
     end
     if (output_counter_reg == 63) begin
         encoder_ready <= 1'b1;
         output_counter_reg <= 1'b0;
        // frame_ready <= 0;
     end

 end
 endmodule


// === Contents from: PNGenerator0000000001.v ===
 module PNGenerator0000000001 (
     input clk,
     input rst,
     input en,
     output pn_out
 );
 wire clk;
 wire rst;
 wire en;
 wire pn_out;
 reg pn_reg_0;
 reg pn_reg_1;
 reg pn_reg_2;
 reg pn_reg_3;
 reg pn_reg_4;
 assign pn_out = pn_reg_0;
 always @ (posedge clk or posedge rst)
 begin
     if (rst) begin
         pn_reg_0 <= 1'b1;
         pn_reg_1 <= 1'b0;
         pn_reg_2 <= 1'b1;
         pn_reg_3 <= 1'b1;
         pn_reg_4 <= 1'b0;
     end else begin
         if (en) begin
             pn_reg_0 <= pn_reg_1 ;
             pn_reg_1 <= pn_reg_2 ;
             pn_reg_2 <= pn_reg_3 ;
             pn_reg_3 <= pn_reg_4 ;
             pn_reg_4 <=
                 (pn_reg_4 & 1'b0) ^
                 (pn_reg_3 ^ 1'b0) ^
                 (pn_reg_2 & 1'b0) ^
                 (pn_reg_1 & 1'b0) ^
                 (pn_reg_0 ^ 1'b0) ^
                 1'b0;
         end
     end
 end
 endmodule


// === Contents from: SingleDecoder0000000001.v ===
 module SingleDecoder0000000001 (
 input [6:0] decoder_in,
 output [3:0] decoder_out
 );
 wire [2:0] syndrome;
 wire [3:0] is_info_bit_wrong;
 assign syndrome[2] = decoder_in[6]^decoder_in[5]^decoder_in[4]^decoder_in[2];
 assign syndrome[1] = decoder_in[6]^decoder_in[5]^decoder_in[3]^decoder_in[1];
 assign syndrome[0] = decoder_in[6]^decoder_in[4]^decoder_in[3]^decoder_in[0];
 assign is_info_bit_wrong[3] = (syndrome==3'b111) ? 1'b1 : 1'b0;
 assign is_info_bit_wrong[2] = (syndrome==3'b110) ? 1'b1 : 1'b0;
 assign is_info_bit_wrong[1] = (syndrome==3'b101) ? 1'b1 : 1'b0;
 assign is_info_bit_wrong[0] = (syndrome==3'b011) ? 1'b1 : 1'b0;
 assign decoder_out[3] = decoder_in[6]^is_info_bit_wrong[3];
 assign decoder_out[2] = decoder_in[5]^is_info_bit_wrong[2];
 assign decoder_out[1] = decoder_in[4]^is_info_bit_wrong[1];
 assign decoder_out[0] = decoder_in[3]^is_info_bit_wrong[0];
 endmodule


// === Contents from: SingleEncoder0000000001.v ===
 module SingleEncoder0000000001 (
     input  [4-1:0] data_in,
     output [7-1:0] data_out
 );
 wire [4-1:0] data_in;
 wire [7-1:0] data_out;
 assign data_out[6] = data_in[3];  // a6
 assign data_out[5] = data_in[2];  // a5
 assign data_out[4] = data_in[1];  // a4
 assign data_out[3] = data_in[0];  // a3
 assign data_out[2] = data_in[3] ^ data_in[2] ^ data_in[1];  // a2
 assign data_out[1] = data_in[3] ^ data_in[2] ^ data_in[0];  // a1
 assign data_out[0] = data_in[3] ^ data_in[1] ^ data_in[0];  // a0
 endmodule


// === Contents from: SyncFrame0000000001.v ===
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
 reg [1:0] forward_false_frame_cnt;
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
              forward_false_frame_cnt <= 2'b0;
              // is_frame_sychronized <= 1'b0;
              // backward_protection_frame_cnt <= 2'b0;
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
                                    if (forward_false_frame_cnt == 2'd1) begin
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



// === Contents from: Tb0000000001.v ===
 module Tb0000000001 ();
 reg clk_in;
 reg clk_out;
 reg rst;
 wire data_in;
 reg data_valid;
 wire data_out;
 wire data_out_error;
 reg [31:0] tx_data_buffer;
 reg data_in_reg;
 wire is_frame_sychronized;
 wire [2:0] synchronizer_state;
 wire data_sync_out;
 wire data_decoder_out;
 initial begin
    clk_in = 0;
    clk_out = 1;
 end
 always #10 clk_in = ~clk_in;  // 20ns周期
 always #5 clk_out = ~clk_out; // 10ns周期
 // Instantiate the Hamming Encoder
HammingEncoder0000000001  u_0000000001_HammingEncoder0000000001(.clk_in(clk_in), .clk_out(clk_out), .rst(rst), .data_in(data_in), .data_valid(data_valid), .data_out(data_out), .data_in_ready(data_in_ready), .data_out_error(data_out_error));
 // Instantiate frame synchronizer
SyncFrame0000000001  u_0000000001_SyncFrame0000000001(.clk_out(clk_out), .rst(rst), .is_frame_sychronized(is_frame_sychronized), .synchronizer_state(synchronizer_state), .data_sync_out(data_sync_out), .data_in(data_out_error));
 // Instantiate the Hamming Decoder
Decoder0000000001  u_0000000001_Decoder0000000001(.clk_decoder_in(clk_out), .clk_decoder_out(clk_in), .rst(rst), .decoder_data_valid(is_frame_sychronized), .data_decoder_in(data_sync_out), .data_decoder_out(data_decoder_out));
PNGenerator0000000001  u_0000000001_PNGenerator0000000001(.clk(clk_in), .rst(rst), .en(data_valid), .pn_out(data_in));
 task send_data;
     input [31:0] data;
     integer i;
     begin
         for (i = 31; i >= 0; i = i - 1) begin
             data_in_reg = data[i];
             data_valid = 1;
             @(posedge clk_in);
         end
         data_valid = 0;
     end
 endtask
 initial begin
     $dumpfile("wave.vcd");
     $dumpvars(0, Tb0000000001);
     # 5
     rst = 1'b1;
     # 20 rst = 1'b0;
     # 20 data_valid = 1'b1;
     @ (posedge clk_in);
     # 15000 $finish;
 end
 integer fd;
 integer fd_decoder_out;
 integer fd_pn_out;
 integer fd_error_out;
 initial begin
   fd = $fopen("encoded_bits.txt", "w");
   fd_decoder_out = $fopen("decoder_out_bits.txt", "w");
   fd_pn_out = $fopen("pn_out_bits.txt", "w");
   fd_error_out = $fopen("error_out_bits.txt", "w");
 end
 always @(posedge clk_out) begin
   // $display("Time:%t Output bit: %b", $time, data_out);
   $fdisplay(fd, "%b", data_out);
 end
 always @(posedge clk_in) begin
   $fdisplay(fd_decoder_out, "%b", data_decoder_out);
 end
 always @(posedge clk_out) begin
   $fdisplay(fd_error_out, "%b", data_out_error);
 end
 always @(posedge clk_in) begin
   $fdisplay(fd_pn_out, "%b", data_in);
 end
 endmodule


