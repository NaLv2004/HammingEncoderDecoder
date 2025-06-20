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
 always #10 clk_in = ~clk_in;  // 20ns����
 always #5 clk_out = ~clk_out; // 10ns����
 assign data_in = data_in_reg;
 // Instantiate the Hamming Encoder
HammingEncoder0000000001  u_0000000001_HammingEncoder0000000001(.clk_in(clk_in), .clk_out(clk_out), .rst(rst), .data_in(data_in), .data_valid(data_valid), .data_out(data_out), .data_in_ready(data_in_ready), .data_out_error(data_out_error));
 // Instantiate frame synchronizer
SyncFrame0000000001  u_0000000001_SyncFrame0000000001(.clk_out(clk_out), .rst(rst), .is_frame_sychronized(is_frame_sychronized), .synchronizer_state(synchronizer_state), .data_sync_out(data_sync_out), .data_in(data_out_error));
 // Instantiate the Hamming Decoder
Decoder0000000001  u_0000000001_Decoder0000000001(.clk_decoder_in(clk_out), .clk_decoder_out(clk_in), .rst(rst), .decoder_data_valid(is_frame_sychronized), .data_decoder_in(data_sync_out), .data_decoder_out(data_decoder_out));
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
     send_data(32'b01100111010010001100110001100001);
     send_data(32'b10101110100011001111001100101101);
     send_data(32'b11101100011110011100111111100001);
     send_data(32'b11000111011100000101000110001111);
     send_data(32'b01111011110110101111000000000100);
     send_data(32'b00111001010110101110100110100001);
     send_data(32'b00100001010011110001100000001000);
     send_data(32'b11111011000001011101000111011011);
     send_data(32'b10011101010011101000100100100001);
     send_data(32'b00011101000110010101110100000001);
     send_data(32'b11111010110111001011111101010010);
     send_data(32'b10011110111101101111111011011111);
     send_data(32'b10010010001101001100111110100110);
     send_data(32'b10110110001111110011100001001101);
     send_data(32'b01001111000101101011111110111101);
     send_data(32'b11010010100101100110010100110001);
     send_data(32'b10111110010110111001011100110110);
     send_data(32'b11111101011111000000111001101110);
     send_data(32'b01010001100011110000011001110010);
     send_data(32'b10010110110111000101001111011110);
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
 endmodule
