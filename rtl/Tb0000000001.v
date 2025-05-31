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
