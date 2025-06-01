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
     send_data(32'b10100100000011100101011111100111);
     send_data(32'b10000101100100000001000100100001);
     send_data(32'b00001111001011000110011001100110);
     send_data(32'b01110001001111100111100001111110);
     send_data(32'b01010111001011010101111011010011);
     send_data(32'b01000010110111111010100011010101);
     send_data(32'b00111111111001001101011000001110);
     send_data(32'b11110111101100010101111010111111);
     send_data(32'b10011110111111011000001000110010);
     send_data(32'b11010111010000011101101101011101);
     send_data(32'b10010001010100101010110101011000);
     send_data(32'b10011001010111000010010100101011);
     send_data(32'b10100101011010000000001011110110);
     send_data(32'b10010011111000111010001101001001);
     send_data(32'b11111111100101100111110001101001);
     send_data(32'b10101010111100101110001101001010);
     send_data(32'b01011010011101101100001110110011);
     send_data(32'b01000000000101100111011111111011);
     send_data(32'b01110000110001101000000011010011);
     send_data(32'b10111111000110001100000101110110);
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
