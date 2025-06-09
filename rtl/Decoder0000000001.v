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
 wire [63:0] decoder_input_data_wire_interleaved;
 assign decoder_input_data_wire_interleaved[63:56] = decoder_input_data_wire[63:56];
 // Interleaving
 assign decoder_input_data_wire_interleaved[0] = decoder_input_data_wire[0];
 assign decoder_input_data_wire_interleaved[1] = decoder_input_data_wire[8];
 assign decoder_input_data_wire_interleaved[2] = decoder_input_data_wire[16];
 assign decoder_input_data_wire_interleaved[3] = decoder_input_data_wire[24];
 assign decoder_input_data_wire_interleaved[4] = decoder_input_data_wire[32];
 assign decoder_input_data_wire_interleaved[5] = decoder_input_data_wire[40];
 assign decoder_input_data_wire_interleaved[6] = decoder_input_data_wire[48];
 assign decoder_input_data_wire_interleaved[7] = decoder_input_data_wire[1];
 assign decoder_input_data_wire_interleaved[8] = decoder_input_data_wire[9];
 assign decoder_input_data_wire_interleaved[9] = decoder_input_data_wire[17];
 assign decoder_input_data_wire_interleaved[10] = decoder_input_data_wire[25];
 assign decoder_input_data_wire_interleaved[11] = decoder_input_data_wire[33];
 assign decoder_input_data_wire_interleaved[12] = decoder_input_data_wire[41];
 assign decoder_input_data_wire_interleaved[13] = decoder_input_data_wire[49];
 assign decoder_input_data_wire_interleaved[14] = decoder_input_data_wire[2];
 assign decoder_input_data_wire_interleaved[15] = decoder_input_data_wire[10];
 assign decoder_input_data_wire_interleaved[16] = decoder_input_data_wire[18];
 assign decoder_input_data_wire_interleaved[17] = decoder_input_data_wire[26];
 assign decoder_input_data_wire_interleaved[18] = decoder_input_data_wire[34];
 assign decoder_input_data_wire_interleaved[19] = decoder_input_data_wire[42];
 assign decoder_input_data_wire_interleaved[20] = decoder_input_data_wire[50];
 assign decoder_input_data_wire_interleaved[21] = decoder_input_data_wire[3];
 assign decoder_input_data_wire_interleaved[22] = decoder_input_data_wire[11];
 assign decoder_input_data_wire_interleaved[23] = decoder_input_data_wire[19];
 assign decoder_input_data_wire_interleaved[24] = decoder_input_data_wire[27];
 assign decoder_input_data_wire_interleaved[25] = decoder_input_data_wire[35];
 assign decoder_input_data_wire_interleaved[26] = decoder_input_data_wire[43];
 assign decoder_input_data_wire_interleaved[27] = decoder_input_data_wire[51];
 assign decoder_input_data_wire_interleaved[28] = decoder_input_data_wire[4];
 assign decoder_input_data_wire_interleaved[29] = decoder_input_data_wire[12];
 assign decoder_input_data_wire_interleaved[30] = decoder_input_data_wire[20];
 assign decoder_input_data_wire_interleaved[31] = decoder_input_data_wire[28];
 assign decoder_input_data_wire_interleaved[32] = decoder_input_data_wire[36];
 assign decoder_input_data_wire_interleaved[33] = decoder_input_data_wire[44];
 assign decoder_input_data_wire_interleaved[34] = decoder_input_data_wire[52];
 assign decoder_input_data_wire_interleaved[35] = decoder_input_data_wire[5];
 assign decoder_input_data_wire_interleaved[36] = decoder_input_data_wire[13];
 assign decoder_input_data_wire_interleaved[37] = decoder_input_data_wire[21];
 assign decoder_input_data_wire_interleaved[38] = decoder_input_data_wire[29];
 assign decoder_input_data_wire_interleaved[39] = decoder_input_data_wire[37];
 assign decoder_input_data_wire_interleaved[40] = decoder_input_data_wire[45];
 assign decoder_input_data_wire_interleaved[41] = decoder_input_data_wire[53];
 assign decoder_input_data_wire_interleaved[42] = decoder_input_data_wire[6];
 assign decoder_input_data_wire_interleaved[43] = decoder_input_data_wire[14];
 assign decoder_input_data_wire_interleaved[44] = decoder_input_data_wire[22];
 assign decoder_input_data_wire_interleaved[45] = decoder_input_data_wire[30];
 assign decoder_input_data_wire_interleaved[46] = decoder_input_data_wire[38];
 assign decoder_input_data_wire_interleaved[47] = decoder_input_data_wire[46];
 assign decoder_input_data_wire_interleaved[48] = decoder_input_data_wire[54];
 assign decoder_input_data_wire_interleaved[49] = decoder_input_data_wire[7];
 assign decoder_input_data_wire_interleaved[50] = decoder_input_data_wire[15];
 assign decoder_input_data_wire_interleaved[51] = decoder_input_data_wire[23];
 assign decoder_input_data_wire_interleaved[52] = decoder_input_data_wire[31];
 assign decoder_input_data_wire_interleaved[53] = decoder_input_data_wire[39];
 assign decoder_input_data_wire_interleaved[54] = decoder_input_data_wire[47];
 assign decoder_input_data_wire_interleaved[55] = decoder_input_data_wire[55];
 // decoding the input data (instantiate 8 single decoders)
SingleDecoder0000000001  u_0000000001_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[6:0]), .decoder_out(decoder_output_data_wire[3:0]));
SingleDecoder0000000001  u_0000000002_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[13:7]), .decoder_out(decoder_output_data_wire[7:4]));
SingleDecoder0000000001  u_0000000003_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[20:14]), .decoder_out(decoder_output_data_wire[11:8]));
SingleDecoder0000000001  u_0000000004_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[27:21]), .decoder_out(decoder_output_data_wire[15:12]));
SingleDecoder0000000001  u_0000000005_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[34:28]), .decoder_out(decoder_output_data_wire[19:16]));
SingleDecoder0000000001  u_0000000006_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[41:35]), .decoder_out(decoder_output_data_wire[23:20]));
SingleDecoder0000000001  u_0000000007_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[48:42]), .decoder_out(decoder_output_data_wire[27:24]));
SingleDecoder0000000001  u_0000000008_SingleDecoder0000000001(.decoder_in(decoder_input_data_wire_interleaved[55:49]), .decoder_out(decoder_output_data_wire[31:28]));
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
