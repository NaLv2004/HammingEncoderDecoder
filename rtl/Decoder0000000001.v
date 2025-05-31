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
