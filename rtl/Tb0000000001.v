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
 initial begin
    clk_in = 0;
    clk_out = 1;
 end
 always #10 clk_in = ~clk_in;  // 20ns周期
 always #5 clk_out = ~clk_out; // 10ns周期
 assign data_in = data_in_reg;
HammingEncoder0000000001  u_0000000001_HammingEncoder0000000001(.clk_in(clk_in), .clk_out(clk_out), .rst(rst), .data_in(data_in), .data_valid(data_valid), .data_out(data_out), .data_in_ready(data_in_ready));
SyncFrame0000000001  u_0000000001_SyncFrame0000000001(.clk_out(clk_out), .rst(rst), .data_in(data_out), .is_frame_sychronized(is_frame_sychronized), .synchronizer_state(synchronizer_state));
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
     send_data(32'b01010011111000011010001101111011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11011011111001100000000011110101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000110101000010001000100001110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01001011010001000011010111011000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01101100011001111111111100001101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10011000100101101111101110110011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11001100100100100011110100101000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10001101111000000101100000011001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100101000001111001011010010101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110110100010010001010000000111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110100101001010111001010010101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01011111011011110010001011010011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00111110001110110010101011101001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00100101010110101001100001100000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011111001111000001110110000101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110010111001010000000001010100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11001010010011101010100011111100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11010011010101100110001010010011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00101001100010010010100111010010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11000111101101010000101110000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00100010110010100001101100101101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10001011001010110010111010000000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10000000000001101000111001110010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000110111010011001000100110010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101001111101011001100001010011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101101101010011000101111101110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01110011000010100000010011001100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110101101000101010111010111100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101100011001000010111011010001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01010000011010110110011000111101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110111111001011101111110011000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111100111010100111011100001011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01000000110001110011001101100010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111100011100111010101110010011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01000001000110110101011000001101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101000011001100100110010100011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11011111011101001000001010101001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00001011011001101011110110010011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110100100111101001001100101110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100111110111001011001111101111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00010101101110011011100010110001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01010101111010011110001101110001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111101101101011111010000101001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10010101101011011011101111010100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00101011010111000111011101111100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11011000010010110000011011000100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111101010101101101110111111101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00010111100110001000100110010011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11101001000100101100010101000000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100100110111110100000010000110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100111110101000110011101011101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110001010000000111000001011110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11101011000101001110100011100010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101100101010111001011111001100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111110111011100011110001010011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01010101011110001000111100101101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111001000000011011110010000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110000101000100011110001001110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10010011111010111001100010100010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000001110111011101110010000001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10010001110110000010101100000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11101010110000010100111001110101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11111010110011000001101000011101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11010000100010011001110001110001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11010011011000111011000100001011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10100100110011110010110011111000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00011111110111100011001111001111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000011011111000110110110001100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00001011010000100010000000010001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00111001011101101000101101011111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00111001001101111010001010000001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10001010110100011111111011111001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01101100111100011011001001011101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00010100011100001111110011011100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00000011111101111000100011100010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10101001111100010110110101001110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00001111111101111011100110010010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01101001010000101101000110011010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00111001000010000110000111100010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00110100100010000111011010001111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11111011101110000110100110011001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10011111110000001111000101110010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01110110111101101100110001101001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10010001110010010010101101001001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11001001111100000011101100110011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100110000110001000111100110100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10010000010001110111011010010000);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10110010010101101000100001001010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01110111111101100000100111111111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11110001001111101101111111111110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b11100011001011111000011010000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10100010010010100110101111100100);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10000010010010010000111001100001);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b00111101100010010111000000000010);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01001100101110000111110101001111);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10111111101010111101110011011110);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01011110000000000110000000010101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01111000001000010111011111001101);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b10010001010100000100001000101011);
     // #20 data_valid = 1'b1;
     // @ (posedge clk_in)
     send_data(32'b01100101111011011100110001101110);
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
