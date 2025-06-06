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
     send_data(32'b01100101110100000111000000111111);
     send_data(32'b01011000000010000111010100011000);
     send_data(32'b01011000010011001101001101010111);
     send_data(32'b10111011001101101010011010011101);
     send_data(32'b01010011010100000111010100110110);
     send_data(32'b00001011101110011010110100000111);
     send_data(32'b10100001100001000000010010111011);
     send_data(32'b10010011011101011101011100101111);
     send_data(32'b01111110101011100100001001000101);
     send_data(32'b00111001011110001110001110101100);
     send_data(32'b11111010101111100000101001110011);
     send_data(32'b11101010100000100111001110101111);
     send_data(32'b11010001001101111001101001000100);
     send_data(32'b00011110000011111111100011111001);
     send_data(32'b00001100001111011111100100110001);
     send_data(32'b00101111110101011101000111001011);
     send_data(32'b11001011100111000011010110101000);
     send_data(32'b10110101001001100010100000111010);
     send_data(32'b00011110010110111011001001101000);
     send_data(32'b01000100101001110001100110100100);
     # 15000 $finish;
 end
 integer fd;
 integer fd_decoder_out;
 integer fd_pn_out;
 initial begin
   fd = $fopen("encoded_bits.txt", "w");
   fd_decoder_out = $fopen("decoder_out_bits.txt", "w");
   fd_pn_out = $fopen("pn_out_bits.txt", "w");
 end
 always @(posedge clk_out) begin
   // $display("Time:%t Output bit: %b", $time, data_out);
   $fdisplay(fd, "%b", data_out);
 end
 always @(posedge clk_in) begin
   $fdisplay(fd_decoder_out, "%b", data_decoder_out);
 end
 endmodule
