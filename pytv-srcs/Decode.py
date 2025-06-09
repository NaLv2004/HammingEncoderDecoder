from pytv import convert
from pytv import moduleloader
import math
@ convert 
def ModuleSingleDecoder(hamming_spec):
    #/ module SingleDecoder(
    #/ input [`hamming_spec.code_length-1`:0] decoder_in,
    #/ output [`hamming_spec.info_length-1`:0] decoder_out
    #/ );
    n_check_bits = hamming_spec.code_length - hamming_spec.info_length
    #/ wire [`n_check_bits-1`:0] syndrome;
    #/ wire [`hamming_spec.info_length-1`:0] is_info_bit_wrong;
    #/ assign syndrome[2] = decoder_in[6]^decoder_in[5]^decoder_in[4]^decoder_in[2];
    #/ assign syndrome[1] = decoder_in[6]^decoder_in[5]^decoder_in[3]^decoder_in[1];
    #/ assign syndrome[0] = decoder_in[6]^decoder_in[4]^decoder_in[3]^decoder_in[0];
    #/ assign is_info_bit_wrong[3] = (syndrome==`n_check_bits`'b111) ? 1'b1 : 1'b0;
    #/ assign is_info_bit_wrong[2] = (syndrome==`n_check_bits`'b110) ? 1'b1 : 1'b0;
    #/ assign is_info_bit_wrong[1] = (syndrome==`n_check_bits`'b101) ? 1'b1 : 1'b0;
    #/ assign is_info_bit_wrong[0] = (syndrome==`n_check_bits`'b011) ? 1'b1 : 1'b0;
    #/ assign decoder_out[3] = decoder_in[6]^is_info_bit_wrong[3];
    #/ assign decoder_out[2] = decoder_in[5]^is_info_bit_wrong[2];
    #/ assign decoder_out[1] = decoder_in[4]^is_info_bit_wrong[1];
    #/ assign decoder_out[0] = decoder_in[3]^is_info_bit_wrong[0];
    #/ endmodule
    pass

 
@ convert
def ModuleDecoder(hamming_spec):
    #/ module Decoder(
    #/     input clk_decoder_in,
    #/     input clk_decoder_out,
    #/     input rst,
    #/     input decoder_data_valid,
    #/     input data_decoder_in,
    #/     output data_decoder_out
    #/ );
    #/ reg [`hamming_spec.frame_length-1`:0] decoder_input_buffer;
    #/ reg [`hamming_spec.data_length-1`:0] decoder_output_buffer;
    #/ reg [`hamming_spec.output_counter_len-1`:0] decoder_input_counter_reg;
    #/ reg [`hamming_spec.input_counter_len-1`:0] decoder_output_counter_reg;
    #/ reg decoder_frame_ready;
    #/ reg decoder_data_out_reg;
    #/ wire [`hamming_spec.frame_length-1`:0] decoder_input_data_wire;
    #/ wire [`hamming_spec.data_length-1`:0] decoder_output_data_wire;
    #/ wire [`hamming_spec.input_counter_len-1`:0] decoder_output_read_idx;
    #/ wire [`hamming_spec.output_counter_len-1`:0] decoder_input_write_idx;
    #/ assign decoder_input_data_wire = decoder_input_buffer;
    #/ // assign decoder_output_data_wire = decoder_output_buffer;
    #/ assign decoder_output_read_idx =`hamming_spec.input_counter_len`'d `hamming_spec.data_length-1`-decoder_output_counter_reg;
    #/ assign decoder_input_write_idx =`hamming_spec.output_counter_len`'d `hamming_spec.frame_length-1`-decoder_input_counter_reg;
    #/ assign data_decoder_out = decoder_data_out_reg;//decoder_output_buffer[decoder_output_read_idx];
    if hamming_spec.flag_interleave:
        #/ wire [`hamming_spec.frame_length-1`:0] decoder_input_data_wire_interleaved;
        pass
    if hamming_spec.flag_interleave:
        #/ assign decoder_input_data_wire_interleaved[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`] = decoder_input_data_wire[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`];
        #/ // Interleaving
        n_codewords = hamming_spec.n_info_groups*math.ceil(hamming_spec.group_length/hamming_spec.info_length)
        for i_codeword in range(0, n_codewords):
            for j_bit in range(0, hamming_spec.code_length):
                #/ assign decoder_input_data_wire_interleaved[`i_codeword*hamming_spec.code_length+j_bit`] = decoder_input_data_wire[`i_codeword+j_bit*n_codewords`];
                pass
            pass
        pass
    #/ // decoding the input data (instantiate 8 single decoders)
    for i in range(0, hamming_spec.n_info_groups*math.ceil(hamming_spec.group_length/hamming_spec.info_length)):
        low_bit_in = i*hamming_spec.info_length
        high_bit_in = (i+1)*hamming_spec.info_length-1
        low_bit_out = i*hamming_spec.code_length
        high_bit_out = (i+1)*hamming_spec.code_length-1
        ports_single_decoder = {
            'decoder_in' : f'decoder_input_data_wire[{high_bit_out}:{low_bit_out}]',
            'decoder_out' : f'decoder_output_data_wire[{high_bit_in}:{low_bit_in}]'
        }
        if hamming_spec.flag_interleave:
            ports_single_decoder['decoder_in'] = f'decoder_input_data_wire_interleaved[{high_bit_out}:{low_bit_out}]'
        ModuleSingleDecoder(hamming_spec=hamming_spec, PORTS = ports_single_decoder)
        pass
    #/ always @(posedge clk_decoder_in or posedge rst)
    #/ begin
    #/     if (rst) begin
    #/         decoder_input_buffer <= `hamming_spec.code_length`'b0;
    #/         decoder_output_buffer <= `hamming_spec.data_length`'b0;
    #/         decoder_input_counter_reg <= 0;
    #/         decoder_output_counter_reg <= 0;
    #/         decoder_frame_ready <= 1'b0;
    #/         decoder_data_out_reg <= 1'b0;
    #/     end else begin
    #/         if (decoder_data_valid) begin
    #/             decoder_input_buffer[decoder_input_write_idx] <= data_decoder_in;
    #/             decoder_input_counter_reg <= decoder_input_counter_reg + 1;
    #/             if (decoder_input_counter_reg == `hamming_spec.frame_length-1`) begin
    #/                  decoder_input_counter_reg <= 0;
    #/                  decoder_frame_ready <= 1'b1;
    #/                  decoder_output_buffer <= decoder_output_data_wire;
    #/             end
    #/         end
    #/     end
    #/ end
    #/ always @(posedge clk_decoder_out or posedge rst)
    #/ begin
    #/     if (decoder_frame_ready) begin
    #/         decoder_data_out_reg <= decoder_output_buffer[decoder_output_read_idx];
    #/         decoder_output_counter_reg <= decoder_output_counter_reg + 1;
    #/     end
    #/     if (decoder_output_counter_reg == `hamming_spec.data_length-1`) begin
    #/         decoder_output_counter_reg <= 0;
    #/     end
    #/ end
    #/ endmodule
    pass
    