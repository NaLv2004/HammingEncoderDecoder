from pytv import convert
from pytv import moduleloader
import math
@ convert
def ModuleSingleEncoder(hamming_spec):
    #/ module SingleEncoder(
    #/     input  [`hamming_spec.info_length`-1:0] data_in,
    #/     output [`hamming_spec.code_length`-1:0] data_out
    #/ );
    #/ wire [`hamming_spec.info_length`-1:0] data_in;
    #/ wire [`hamming_spec.code_length`-1:0] data_out;
    #/ assign data_out[6] = data_in[3];  // a6
    #/ assign data_out[5] = data_in[2];  // a5
    #/ assign data_out[4] = data_in[1];  // a4
    #/ assign data_out[3] = data_in[0];  // a3
    #/ assign data_out[2] = data_in[3] ^ data_in[2] ^ data_in[1];  // a2
    #/ assign data_out[1] = data_in[3] ^ data_in[2] ^ data_in[0];  // a1
    #/ assign data_out[0] = data_in[3] ^ data_in[1] ^ data_in[0];  // a0
    #/ endmodule
    pass
    
    
@ convert 
def ModuleHammingEncoder(hamming_spec):
    #/ module HammingEncoder(
    #/     input clk_in,
    #/     input clk_out,
    #/     input rst,
    #/     input data_in,
    #/     input data_valid,
    #/     output data_out,
    #/     output data_in_ready
    #/ );
    #/ wire clk_in;
    #/ wire clk_out;
    #/ wire rst;
    #/ wire data_in;
    #/ wire data_valid;
    #/ wire data_out;
    #/ wire data_in_ready;
    #/ wire frame_ready_wire;
    #/ reg input_bit_reg;
    #/ reg [`hamming_spec.frame_length-1`:0] tx_frame_buffer;
    #/ reg [`hamming_spec.data_length-1`:0] input_data_buffer;
    #/ reg [`hamming_spec.input_counter_len-1`:0] input_counter_reg;
    #/ reg [`hamming_spec.output_counter_len-1`:0] output_counter_reg;
    #/ reg [`hamming_spec.input_counter_len-1`:0] input_counter_reg_prev;
    #/ reg [`hamming_spec.input_counter_len-1`:0] input_counter_reg_delayed_clkout_1;
    #/ reg [`hamming_spec.input_counter_len-1`:0] input_counter_reg_delayed_clkout_2;
    #/ reg [`hamming_spec.input_counter_len-1`:0] input_counter_reg_delayed_clkout_3;
    #/ wire [`hamming_spec.input_counter_len-1`:0] input_write_idx;
    #/ wire [`hamming_spec.output_counter_len-1`:0] output_read_idx;
    #/ wire [`hamming_spec.frame_length-1`:0] tx_frame_wire;
    #/ wire [`hamming_spec.data_length-1`:0] input_data_wire;
    #/ reg [8:0] n_frames_sent;
    if hamming_spec.flag_interleave:
        #/ wire [`hamming_spec.frame_length-1`:0] tx_frame_wire_interleaved;
        pass
    #/ reg frame_ready;
    #/ reg encoder_ready;
    #/ reg data_buffer_ready;
    #/ reg data_out_reg;
    #/ assign data_out = data_out_reg;
    #/ assign data_in_ready = data_buffer_ready;
    #/ // the higher bits are transmitted first
    #/ assign input_data_wire = input_data_buffer;
    #/ assign frame_ready_wire = ((input_counter_reg_delayed_clkout_1 == `hamming_spec.data_length-1`) && (input_counter_reg==0))? 1 : 0;
    #/ assign input_write_idx =`hamming_spec.input_counter_len`'d `hamming_spec.data_length-1`-input_counter_reg;
    #/ assign output_read_idx =`hamming_spec.output_counter_len`'d `hamming_spec.frame_length-1`-output_counter_reg;
    #/ // frame head for synchronization
    # / assign tx_frame_wire[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`] = (n_frames_sent == 1) ?`hamming_spec.frame_head_length`'b01111110 : 
    # /                                                                                                                  (n_frames_sent == 5) ? `hamming_spec.frame_head_length`'b01111110
    # /    
    #                                                                                                      : `hamming_spec.frame_head_length`'b01111110;
    # Set the frame heads in error
    if hamming_spec.frame_head_errors is not None:
        #/ assign tx_frame_wire[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`] = 
        for idx, i_error_head in enumerate(hamming_spec.frame_head_errors):
            #/     (n_frames_sent == `i_error_head`) ? `hamming_spec.frame_head_length`'b01101110 : 
            pass
        pass
        #/     `hamming_spec.frame_head_length`'b01111110;
    else:
        #/ assign tx_frame_wire[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`] = `hamming_spec.frame_head_length`'b01111110;
        pass
    if hamming_spec.flag_interleave:
        #/ assign tx_frame_wire_interleaved[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`] = tx_frame_wire[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`];
        #/ // Interleaving
        n_codewords = hamming_spec.n_info_groups*math.ceil(hamming_spec.group_length/hamming_spec.info_length)
        for i_codeword in range(0, n_codewords):
            for j_bit in range(0, hamming_spec.code_length):
                #/ assign tx_frame_wire_interleaved[`i_codeword+j_bit*n_codewords`] = tx_frame_wire[`i_codeword*hamming_spec.code_length+j_bit`];
                pass
            pass
        pass
    #/ // assign encoding input to data input buffer,  assign tx_frame_wire to encoding output
    #/ // instantiate single encoder for each group of data
    for i in range(0, hamming_spec.n_info_groups*math.ceil(hamming_spec.group_length/hamming_spec.info_length)):
        low_bit_in = i*hamming_spec.info_length
        high_bit_in = (i+1)*hamming_spec.info_length-1
        low_bit_out = i*hamming_spec.code_length
        high_bit_out = (i+1)*hamming_spec.code_length-1
        ports_single_encoder = {
            'data_in' : f'input_data_wire[{high_bit_in}:{low_bit_in}]',
            'data_out' : f'tx_frame_wire[{high_bit_out}:{low_bit_out}]'
        }
        ModuleSingleEncoder(hamming_spec=hamming_spec, PORTS = ports_single_encoder)
        pass
    #/ always @ (posedge clk_in or posedge rst)
   
    #/ begin
    #/ input_counter_reg_prev <= input_counter_reg;
    #/     if (rst) begin
    #/         tx_frame_buffer <= `hamming_spec.frame_length`'b0;
    #/         input_data_buffer <= `hamming_spec.data_length`'b0;
    #/         input_counter_reg <= `hamming_spec.input_counter_len`'b0;
    #/         output_counter_reg <= `hamming_spec.output_counter_len`'b0;
    #/         input_bit_reg <= 1'b0;
    #/         frame_ready <= 0;
    #/         data_out_reg <= 0;
    #/         encoder_ready <= 1'b1;
    #/         data_buffer_ready <= 1'b1;
    #/         n_frames_sent <= 0;
    #/     end  else begin
    #/         if (data_valid ) begin
    #/             input_data_buffer[input_write_idx] <= data_in;
    #/             input_counter_reg <= input_counter_reg + 1;
    #/             data_buffer_ready <= 1'b0;
    #/             input_bit_reg <= data_in;
    #/          end
    #/         if (input_counter_reg == `hamming_spec.data_length-1`) begin // input_counter_reg_prev == `hamming_spec.data_length-1`
    #/             // frame_ready <= 1'b1;
    #/             input_counter_reg <= 0;
    #/             data_buffer_ready <= 1'b1;
    #/             encoder_ready <= 1'b0;
    #/         end
    #/     end
    #/ end
    #/ // output data with twice the rate of input data
    #/ always @ (posedge clk_out or posedge rst)
    #/ begin
    #/     input_counter_reg_delayed_clkout_1 <= input_counter_reg;
    #/     input_counter_reg_delayed_clkout_2 <= input_counter_reg_delayed_clkout_1;
    #/     input_counter_reg_delayed_clkout_3 <= input_counter_reg_delayed_clkout_2;
    #/     if (frame_ready_wire) begin
    #/          frame_ready <= 1'b1;
    if not hamming_spec.flag_interleave:
        #/             tx_frame_buffer <= tx_frame_wire;
        pass
    else:
        #/             tx_frame_buffer <= tx_frame_wire_interleaved;
        pass
    #/          n_frames_sent <= n_frames_sent + 1;
    #/     end
    #/     if (frame_ready) begin
    #/         output_counter_reg <= output_counter_reg + 1;
    #/         data_out_reg <= tx_frame_buffer[output_read_idx];
    #/        
    #/        // encoder_ready <= 1'b0;
    #/     end
    #/     if (output_counter_reg == `hamming_spec.frame_length-1`) begin
    #/         encoder_ready <= 1'b1;
    #/         output_counter_reg <= 1'b0;
    #/        // frame_ready <= 0;
    #/     end
    #/ 
    #/ end
    #/ endmodule
    pass