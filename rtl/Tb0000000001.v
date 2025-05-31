 module Tb0000000001 ();
 reg clk_in;
 reg clk_out;
 reg rst;
 wire data_in;
 reg data_valid;
 wire data_out;
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
 assign data_in = data_in_reg;
 // Instantiate the Hamming Encoder
HammingEncoder0000000001  u_0000000001_HammingEncoder0000000001(.clk_in(clk_in), .clk_out(clk_out), .rst(rst), .data_in(data_in), .data_valid(data_valid), .data_out(data_out), .data_in_ready(data_in_ready));
 // Instantiate frame synchronizer
SyncFrame0000000001  u_0000000001_SyncFrame0000000001(.clk_out(clk_out), .rst(rst), .data_in(data_out), .is_frame_sychronized(is_frame_sychronized), .synchronizer_state(synchronizer_state), .data_sync_out(data_sync_out));
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
     send_data(32'b11110011111010110101010011110110);
     send_data(32'b11000100100011110100110011100111);
     send_data(32'b10101100001010100000001110001101);
     send_data(32'b10001001101010110110011100111101);
     send_data(32'b01101000111111110110010011010111);
     send_data(32'b01011010000110011111001001010111);
     send_data(32'b11011001110101000011110110000101);
     send_data(32'b11110100111101001100110100001110);
     send_data(32'b10100100101101101000000110100100);
     send_data(32'b10100000101101101100010110101010);
     send_data(32'b01011011100001011101100111110001);
     send_data(32'b01010100001000100100110110100011);
     send_data(32'b01010100000000000001100001001011);
     send_data(32'b00011101010001101011111010001101);
     send_data(32'b01101100100101101001001000110110);
     send_data(32'b01110101111011010011010110110111);
     send_data(32'b10101011010110010011110000000000);
     send_data(32'b10000010100111101100011110100100);
     send_data(32'b01110101110011101000110101110000);
     send_data(32'b01100010100001000010000111101100);
     # 1500 $finish;
 end
 integer fd;
 integer fd_decoder_out;
 initial begin
   fd = $fopen("encoded_bits.txt", "w");
   fd_decoder_out = $fopen("decoder_out_bits.txt", "w");
 end
 always @(posedge clk_out) begin
   // $display("Time:%t Output bit: %b", $time, data_out);
   $fdisplay(fd, "%b", data_out);
 end
 always @(posedge clk_in) begin
   $fdisplay(fd_decoder_out, "%b", data_decoder_out);
 end
 endmodule
