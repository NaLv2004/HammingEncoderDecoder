 module SingleDecoder0000000001 (
 input [6:0] decoder_in,
 output [3:0] decoder_out
 );
 wire [2:0] syndrome;
 wire [3:0] is_info_bit_wrong;
 assign syndrome[2] = decoder_in[6]^decoder_in[5]^decoder_in[4]^decoder_in[2];
 assign syndrome[1] = decoder_in[6]^decoder_in[5]^decoder_in[3]^decoder_in[1];
 assign syndrome[0] = decoder_in[6]^decoder_in[4]^decoder_in[3]^decoder_in[0];
 assign is_info_bit_wrong[3] = (syndrome==3'b111) ? 1'b1 : 1'b0;
 assign is_info_bit_wrong[2] = (syndrome==3'b110) ? 1'b1 : 1'b0;
 assign is_info_bit_wrong[1] = (syndrome==3'b101) ? 1'b1 : 1'b0;
 assign is_info_bit_wrong[0] = (syndrome==3'b011) ? 1'b1 : 1'b0;
 assign decoder_out[3] = decoder_in[6]^is_info_bit_wrong[3];
 assign decoder_out[2] = decoder_in[5]^is_info_bit_wrong[2];
 assign decoder_out[1] = decoder_in[4]^is_info_bit_wrong[1];
 assign decoder_out[0] = decoder_in[3]^is_info_bit_wrong[0];
 endmodule
