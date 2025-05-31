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
     send_data(32'b10111001110110101000101000101000);
     send_data(32'b01010010111010010100110000000010);
     send_data(32'b00101001110110101110000111100000);
     send_data(32'b11111010010100000010111000110000);
     send_data(32'b00010000010010010111111011011110);
     send_data(32'b10111111000000100101001111011100);
     send_data(32'b11000111111011101011101110011101);
     send_data(32'b11001100110111000011110111110011);
     send_data(32'b01000011111111101100101100101000);
     send_data(32'b11011111011001001010101100110101);
     send_data(32'b01101110001100010101010001001101);
     send_data(32'b00001011010111010110111000000110);
     send_data(32'b10011001101011010000011100010011);
     send_data(32'b00110010001001100101111101011100);
     send_data(32'b10101010010001110001001111001011);
     send_data(32'b10101111001011101101011011001000);
     send_data(32'b00100001101111110110110011100100);
     send_data(32'b01010010001111111100011001100000);
     send_data(32'b10000100011001000110000111001111);
     send_data(32'b11010101000101000010110110011101);
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
