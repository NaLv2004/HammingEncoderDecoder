// === Contents from: HammingEncoder0000000001.v ===
 module HammingEncoder0000000001 (
     input clk_in,
     input clk_out,
     input rst,
     input data_in,
     input data_valid,
     output data_out,
     output data_in_ready
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
 wire [63:0] tx_frame_wire_interleaved;
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
 // frame head for synchronization
 assign tx_frame_wire[63:56] = 8'b01111110;
 assign tx_frame_wire_interleaved[63:56] = tx_frame_wire[63:56];
 // Interleaving
 assign tx_frame_wire_interleaved[0] = tx_frame_wire[0];
 assign tx_frame_wire_interleaved[8] = tx_frame_wire[1];
 assign tx_frame_wire_interleaved[16] = tx_frame_wire[2];
 assign tx_frame_wire_interleaved[24] = tx_frame_wire[3];
 assign tx_frame_wire_interleaved[32] = tx_frame_wire[4];
 assign tx_frame_wire_interleaved[40] = tx_frame_wire[5];
 assign tx_frame_wire_interleaved[48] = tx_frame_wire[6];
 assign tx_frame_wire_interleaved[1] = tx_frame_wire[7];
 assign tx_frame_wire_interleaved[9] = tx_frame_wire[8];
 assign tx_frame_wire_interleaved[17] = tx_frame_wire[9];
 assign tx_frame_wire_interleaved[25] = tx_frame_wire[10];
 assign tx_frame_wire_interleaved[33] = tx_frame_wire[11];
 assign tx_frame_wire_interleaved[41] = tx_frame_wire[12];
 assign tx_frame_wire_interleaved[49] = tx_frame_wire[13];
 assign tx_frame_wire_interleaved[2] = tx_frame_wire[14];
 assign tx_frame_wire_interleaved[10] = tx_frame_wire[15];
 assign tx_frame_wire_interleaved[18] = tx_frame_wire[16];
 assign tx_frame_wire_interleaved[26] = tx_frame_wire[17];
 assign tx_frame_wire_interleaved[34] = tx_frame_wire[18];
 assign tx_frame_wire_interleaved[42] = tx_frame_wire[19];
 assign tx_frame_wire_interleaved[50] = tx_frame_wire[20];
 assign tx_frame_wire_interleaved[3] = tx_frame_wire[21];
 assign tx_frame_wire_interleaved[11] = tx_frame_wire[22];
 assign tx_frame_wire_interleaved[19] = tx_frame_wire[23];
 assign tx_frame_wire_interleaved[27] = tx_frame_wire[24];
 assign tx_frame_wire_interleaved[35] = tx_frame_wire[25];
 assign tx_frame_wire_interleaved[43] = tx_frame_wire[26];
 assign tx_frame_wire_interleaved[51] = tx_frame_wire[27];
 assign tx_frame_wire_interleaved[4] = tx_frame_wire[28];
 assign tx_frame_wire_interleaved[12] = tx_frame_wire[29];
 assign tx_frame_wire_interleaved[20] = tx_frame_wire[30];
 assign tx_frame_wire_interleaved[28] = tx_frame_wire[31];
 assign tx_frame_wire_interleaved[36] = tx_frame_wire[32];
 assign tx_frame_wire_interleaved[44] = tx_frame_wire[33];
 assign tx_frame_wire_interleaved[52] = tx_frame_wire[34];
 assign tx_frame_wire_interleaved[5] = tx_frame_wire[35];
 assign tx_frame_wire_interleaved[13] = tx_frame_wire[36];
 assign tx_frame_wire_interleaved[21] = tx_frame_wire[37];
 assign tx_frame_wire_interleaved[29] = tx_frame_wire[38];
 assign tx_frame_wire_interleaved[37] = tx_frame_wire[39];
 assign tx_frame_wire_interleaved[45] = tx_frame_wire[40];
 assign tx_frame_wire_interleaved[53] = tx_frame_wire[41];
 assign tx_frame_wire_interleaved[6] = tx_frame_wire[42];
 assign tx_frame_wire_interleaved[14] = tx_frame_wire[43];
 assign tx_frame_wire_interleaved[22] = tx_frame_wire[44];
 assign tx_frame_wire_interleaved[30] = tx_frame_wire[45];
 assign tx_frame_wire_interleaved[38] = tx_frame_wire[46];
 assign tx_frame_wire_interleaved[46] = tx_frame_wire[47];
 assign tx_frame_wire_interleaved[54] = tx_frame_wire[48];
 assign tx_frame_wire_interleaved[7] = tx_frame_wire[49];
 assign tx_frame_wire_interleaved[15] = tx_frame_wire[50];
 assign tx_frame_wire_interleaved[23] = tx_frame_wire[51];
 assign tx_frame_wire_interleaved[31] = tx_frame_wire[52];
 assign tx_frame_wire_interleaved[39] = tx_frame_wire[53];
 assign tx_frame_wire_interleaved[47] = tx_frame_wire[54];
 assign tx_frame_wire_interleaved[55] = tx_frame_wire[55];
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
             tx_frame_buffer <= tx_frame_wire_interleaved;

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


// === Contents from: Tb0000000001.v ===
 module Tb0000000001 ();
 reg clk_in;
 reg clk_out;
 reg rst;
 wire data_in;
 reg data_valid;
 wire data_out;
 reg [31:0] tx_data_buffer;
 reg data_in_reg;
 initial begin
    clk_in = 0;
    clk_out = 1;
 end
 always #10 clk_in = ~clk_in;  // 20ns周期
 always #5 clk_out = ~clk_out; // 10ns周期
 assign data_in = data_in_reg;
HammingEncoder0000000001  u_0000000001_HammingEncoder0000000001(.clk_in(clk_in), .clk_out(clk_out), .rst(rst), .data_in(data_in), .data_valid(data_valid), .data_out(data_out), .data_in_ready(data_in_ready));
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
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111001101000011110011100010100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01101110010011100011000011011011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111101110000000110000101001001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100101101001010101110111101000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00010001010011101111101010010010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00100011101011101001100100100110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10011000010101111011010100101011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000011101100001111101111110010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10011001101101100011001001011000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111110110000101011011001110110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10001110110111100000110100111110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01101111101010101000110111110110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110001000100100011010011000101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00101000111010111010010110100101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100000111101110110111110001101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01001101011111101101000001000101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10011001111001001010010011010000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110111000110111011001010000101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00010100001001101011011111100101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01110100001000100001111010000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110110010100100000101100110110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011000011011111100101000000110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011100001000000110101111100000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00010011010001001000010100011100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110100100111011011000011000101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01010111101101100100001010010101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000110001111000001101000110011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110110100011100000010110101010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111011111010001011000111101100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000100101000010101010011111110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01001011111110100000001000110001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11011011000110000000100001101011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100111101001110101000011011000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01001010010101010000101100101100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110011100111100010111100000001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01101011010110000100000010000001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110100000111100101100100111110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10011100011011111011111010110111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01010101100000010001101100101001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10010111000110100100111110111101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100111110111000110110001101111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10000011001000111110010100001001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01010100000110000111101100011000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111110010000011100001000001110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101100111111111011111000111001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01011001010100101100001000111011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01011101111010111001110001110001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000010110110111110110111110000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000111111110001111000001000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11101011010001000000111010011101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01010010001110101101001100000101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00001110011101001011110110100101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01001011111110011110111001100001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00100000011010001110100001011100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110111100110000110011000101001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000100100000010101001110010111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10001111111001100010001100110111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00100011000011101011101000101110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11011011000001000101000101100100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000110011111101000010011001100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110011100100011100010101001101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100001110011011010000100110111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100011100111000010110110010001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00010011111100110101111100100001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110100010111100010001010110010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110001011100011110101000111111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110111101101011101110000111010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011110110010000111000010000011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011000110111110100111000000100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011101010111110101010110101000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011111110101000010010111110011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111001010100010010111101111001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00001001001000000100101100111110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11001100001001101111111111100111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111001010001110101110101111001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000100111110001001100111011010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101100110110000101000110110110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100000101000010010101011100011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110110010010100100000101010110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00111110110101100100100100111000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100100011111000010011010011110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10011000001011011010000110101100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111101011111100111111101110000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11001010011001000110100011011010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101011100100000011111011111110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000101011001101000110111001001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110011110001000100100011010100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10001000000010001011111110100111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100011000011110100010101100100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100100111100101101011111000011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111011000011111011110110010110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110110001111010101101010010101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111101101000000000010010111101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01100001110111011010000100100110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000001001000100000100010100011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000110100111011111110110010111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11111010100101110101110011100101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11111010001001100100100111000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01011100001101110111000100110111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01110001101000101100100011001101);
     # 1500 $finish;
 end
 integer fd;
 initial begin
   fd = $fopen("encoded_bits.txt", "w");
 end
 always @(posedge clk_out) begin
   // $display("Time:%t Output bit: %b", $time, data_out);
   $fdisplay(fd, "%b", data_out);
 end
 endmodule


