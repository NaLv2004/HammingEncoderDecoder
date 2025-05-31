import sys
import shutil
import os
from os.path import dirname, abspath
sys.path.append(dirname(dirname(__file__)))
sys.path.append(dirname(__file__))

import random
import pytv
from pytv import convert
from pytv import moduleloader
import math
from run_iverilog import run_iverilog_flow





# moduleloader.set_debug_mode(True)
# moduleloader.set_root_dir("D:\\ChannelCoding\\AutoGen\\Verilog\\HammingEncoderDecoder\\RTL")
# moduleloader.disEnableWarning()



class hamming_spec:
    def __init__(self, flag_interleave=False):
        self.code_length = 7
        self.info_length = 4
        self.frame_head_length = 8
        self.n_info_groups = 2
        self.group_length = 16
        self.n_tx_frames = 100
        self.frame_length = int(self.frame_head_length + round(self.group_length/self.info_length) * self.code_length * self.n_info_groups)
        self.data_length = self.group_length * self.n_info_groups
        self.input_counter_len = math.ceil(math.log2(self.group_length*self.n_info_groups))+1
        self.output_counter_len = math.ceil(math.log2(self.frame_length))+1
        self.flag_interleave = flag_interleave
        self.info_bits = []
        self.info_bits_str = []
        self.encoded_bits_expected = []
        self.encoded_bits_expected_str = []
        self.frame_head_str = '01111110'
        # synchronization parameters
        self.backward_frame_head_error = 0   # Allowed bit errors in frame head during backward protection
        self.backward_correct_frame_cnt = 1  # Number of correct frames during backward protection to enter sync state
        self.capture_error = 0               # Allowed errors in frame head to remain in sync state
        self.forward_false_frame_cnt = 0     # Number of false frames during forward protection to re-enter capture state
        self.backward_correct_frame_cnt_width = math.ceil(math.log2(self.backward_correct_frame_cnt+1)) + 1
        self.forward_false_frame_cnt_width = math.ceil(math.log2(self.forward_false_frame_cnt+1)) + 1
        self.generate_info_bits()
        self.generate_encoded_bits_expected()
        print(f"info_bits:")
        print(f"{self.info_bits_str}")
        print(f"encoded_bits:")
        print(f"{self.encoded_bits_expected_str}")
        
        
    def generate_info_bits(self):
        for i in range(0, self.n_tx_frames):
            
            info_bits_single_frame = []
            info_bits_single_frame_str = ""
            for j in range(0, self.data_length):
            # randomly generate 0 or 1
                bit = random.randint(0,1)
                info_bits_single_frame.append(bit)
                info_bits_single_frame_str += str(bit)
            self.info_bits.append(info_bits_single_frame)
            self.info_bits_str.append(info_bits_single_frame_str)
            
            
    def generate_encoded_bits_expected(self):
        for i in range(0, self.n_tx_frames):
            encoded_bits_single_frame = []
            encoded_bits_single_frame_str = ""
            # frame head
            encoded_bits_single_frame += [0,1,1,1,1,1,1,0]
            if (False) :
               encoded_bits_single_frame_str += '01101110'
            else:
               encoded_bits_single_frame_str += '01111110'
            # encoded bits
            for j in range(0, self.n_info_groups*round(self.group_length/self.info_length)):
                for k in range(0, self.code_length):
                    if k<self.info_length:
                        bit = self.info_bits[i][j*self.info_length+k]
                        encoded_bits_single_frame.append(bit)
                        encoded_bits_single_frame_str+=(str(bit))
                    else:
                        if k==4:
                            bit = self.info_bits[i][j*self.info_length+0] ^ self.info_bits[i][j*self.info_length+1] ^ self.info_bits[i][j*self.info_length+2] 
                        
                        if k==5:
                            bit = self.info_bits[i][j*self.info_length+0] ^ self.info_bits[i][j*self.info_length+1] ^ self.info_bits[i][j*self.info_length+3] 
                        
                        if k==6:
                            bit = self.info_bits[i][j*self.info_length+0] ^ self.info_bits[i][j*self.info_length+2] ^ self.info_bits[i][j*self.info_length+3] 
                        
                        encoded_bits_single_frame.append(bit)
                        encoded_bits_single_frame_str += (str(bit))
            
            if self.flag_interleave:
                # reverse the order of bits
                # print(f"encoded bits")
                # print(f"{encoded_bits_single_frame}")
                encoded_bits_single_frame_reverse = encoded_bits_single_frame[::-1]
                # print(f"encoded bits reverse")
                # print(f"{encoded_bits_single_frame_reverse}")
                # print(f"encoded_bits_single_frame_after")
                # print(f"{encoded_bits_single_frame}")
                encoded_bits_single_frame_reverse_interleaved = encoded_bits_single_frame_reverse.copy()
                # interleave the bits
                n_codewords = self.n_info_groups*math.ceil(self.group_length/self.info_length)
                for i_codeword in range(0, n_codewords):
                    for j_bit in range(0, self.code_length):
                        encoded_bits_single_frame_reverse_interleaved[j_bit*n_codewords+i_codeword] = encoded_bits_single_frame_reverse[i_codeword*self.code_length+j_bit]
                        #print(f"{j_bit*n_codewords+i_codeword}<= {i_codeword*self.code_length+j_bit}")
                        
                # for i_codeword in range(0, n_codewords):
                #     for j_bit in range(0, self.code_length):
                #         if encoded_bits_single_frame_reverse_interleaved[j_bit*n_codewords+i_codeword] == encoded_bits_single_frame_reverse[i_codeword*self.code_length+j_bit]:
                #             print(f"Equal")
                #         else: 
                #             print(f"FAIL")
                        
                encoded_bits_single_frame = encoded_bits_single_frame_reverse_interleaved[::-1]
                encoded_bits_single_frame_str = ""
                for i_bit in range(0, self.frame_length):
                    encoded_bits_single_frame_str += str(encoded_bits_single_frame[i_bit])
                        
            self.encoded_bits_expected.append(encoded_bits_single_frame)
            self.encoded_bits_expected_str.append(encoded_bits_single_frame_str)



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
    #/ assign tx_frame_wire[`hamming_spec.frame_length-1`:`hamming_spec.frame_length-hamming_spec.frame_head_length`] = (n_frames_sent == 1) ?`hamming_spec.frame_head_length`'b01111110 : 
    #/                                                                                                                  (n_frames_sent == 5) ? `hamming_spec.frame_head_length`'b01111110
    #/                                                                                                                  : `hamming_spec.frame_head_length`'b01111110;
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
    
    
@ convert
def ModuleSyncFrame(hamming_spec):
    #/ module SyncFrame(
    #/     input clk_out,
    #/     input rst,
    #/     input data_in,
    #/     output is_frame_sychronized,
    #/     output [2:0] synchronizer_state,
    #/     output data_sync_out
    #/ );
    # state definitions
    CAPTURE = "3'b000"
    FORWARD_PROTECTION = "3'b001"
    SYNC = "3'b010"
    BACKWARD_PROTECTION = "3'b011"
    #/ wire [2:0] synchronizer_state;
    #/ reg [2:0] sychronizer_state_reg;
    #/ reg [`hamming_spec.backward_correct_frame_cnt_width-1`:0] backward_correct_frame_cnt;
    #/ reg [`hamming_spec.forward_false_frame_cnt_width-1`:0] forward_false_frame_cnt;
    #/ reg [`hamming_spec.frame_head_length-1`:0] frame_head_buffer;
    #/ reg [`hamming_spec.output_counter_len-1`:0] input_bit_counter;
    #/ reg data_sync_out_delayed;
    #/ assign synchronizer_state = sychronizer_state_reg;
    #/ assign is_frame_sychronized = (sychronizer_state_reg == `SYNC`)? 1'b1 : 1'b0;
    #/ assign data_sync_out = data_sync_out_delayed; //frame_head_buffer[`hamming_spec.frame_head_length-1`:`hamming_spec.frame_head_length-1`];
    # // sliding window register for detecting frame head  
    #/ always @ (posedge clk_out or posedge rst)
    #/ begin
    #/     if (rst) begin
    #/         data_sync_out_delayed <= 1'b0;
    #/         sychronizer_state_reg <= `CAPTURE`;
    #/         frame_head_buffer <= `hamming_spec.frame_length`'b0;
    #/         // is_frame_sychronized <= 1'b0;
    #/     end else begin
    #/         data_sync_out_delayed <= frame_head_buffer[`hamming_spec.frame_head_length-1`:`hamming_spec.frame_head_length-1`];
    #/         frame_head_buffer[0] <= data_in;
    for i in range(1, hamming_spec.frame_head_length):
        #/         frame_head_buffer[`i`] <= frame_head_buffer[`i-1`];
        pass
    #/     end
    #/ end
    #/ // state transition logic
    #/ always @ (posedge clk_out or posedge rst)
    #/ begin
    #/       if (rst) begin
    #/              sychronizer_state_reg <= `CAPTURE`;
    #/              backward_correct_frame_cnt <= `hamming_spec.backward_correct_frame_cnt_width`'b0;
    #/              forward_false_frame_cnt <= `hamming_spec.forward_false_frame_cnt_width`'b0;
    #/              // is_frame_sychronized <= 1'b0;
    #/              // backward_protection_frame_cnt <= `hamming_spec.forward_false_frame_cnt_width`'b0;
    #/              input_bit_counter <= `hamming_spec.output_counter_len`'b0;
    #/          end
    #/      case (sychronizer_state_reg)
    #/         
    #/          // CAPTURE:
    #/          // if current frame buffer matches the frame head, move to BACKWARD_PROTECTION state and set correct frame counter to 1
    #/          `CAPTURE`:
    #/                  begin
    #/                      if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                          sychronizer_state_reg <= `BACKWARD_PROTECTION`;
    #/                          backward_correct_frame_cnt <= 1;
    #/                      end else begin 
    #/                          sychronizer_state_reg <= `CAPTURE`;
    #/                          input_bit_counter <= 0;
    #/                      end
    #/                  end
    #/          `BACKWARD_PROTECTION`:
    #/                  begin
    #/                        if (input_bit_counter == `hamming_spec.output_counter_len`'d`hamming_spec.frame_length-1`) begin
    #/                            input_bit_counter <= 0;
    #/                            if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                                backward_correct_frame_cnt <= backward_correct_frame_cnt + 1;
    #/                                if (backward_correct_frame_cnt == `hamming_spec.backward_correct_frame_cnt_width`'d`hamming_spec.backward_correct_frame_cnt`) begin
    #/                                     sychronizer_state_reg <= `SYNC`;
    #/                                end else begin
    #/                                     sychronizer_state_reg <= `BACKWARD_PROTECTION`;
    #/                                end
    #/                            end
    #/                            else begin
    #/                                backward_correct_frame_cnt <= 0;
    #/                                sychronizer_state_reg <= `CAPTURE`;
    #/                            end
    #/                        end else begin 
    #/                            input_bit_counter <= input_bit_counter + 1;
    #/                            sychronizer_state_reg <= `BACKWARD_PROTECTION`;
    #/                        end
    #/                  end
    #/          `SYNC`:
    #/                  begin
    #/                       if (input_bit_counter == `hamming_spec.output_counter_len`'d`hamming_spec.frame_length-1`) begin
    #/                            input_bit_counter <= 0;
    #/                            if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                                sychronizer_state_reg <= `SYNC`;
    #/                            end else begin 
    #/                                sychronizer_state_reg <= `FORWARD_PROTECTION`;
    #/                                forward_false_frame_cnt <= 0;
    #/                            end
    #/                       end else begin
    #/                            input_bit_counter <= input_bit_counter + 1;
    #/                            sychronizer_state_reg <= `SYNC`;
    #/                       end
    #/                  end
    #/          `FORWARD_PROTECTION`:
    #/                  begin
    #/                         if (input_bit_counter == `hamming_spec.output_counter_len`'d`hamming_spec.frame_length-1`) begin
    #/                                input_bit_counter <= 0;
    #/                                if (frame_head_buffer == `hamming_spec.frame_head_length`'b`hamming_spec.frame_head_str`) begin
    #/                                    sychronizer_state_reg <= `SYNC`;
    #/                                    forward_false_frame_cnt <= 0;
    #/                                end else begin 
    #/                                    forward_false_frame_cnt <= forward_false_frame_cnt + 1;
    #/                                    if (forward_false_frame_cnt == `hamming_spec.forward_false_frame_cnt_width`'d`hamming_spec.forward_false_frame_cnt`) begin
    #/                                         sychronizer_state_reg <= `CAPTURE`;
    #/                                     end else begin
    #/                                         sychronizer_state_reg <= `FORWARD_PROTECTION`;
    #/                                     end
    #/                                end
    #/                          end else begin
    #/                                input_bit_counter <= input_bit_counter + 1;
    #/                                sychronizer_state_reg <= `FORWARD_PROTECTION`;
    #/                          end
    #/                  end
    #/      endcase
    #/ end
    #/ endmodule
    #/ 


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
    
    
    
    
    
    
    
@ convert 
def ModuleTb(hamming_spec):
    #/ module Tb();
    #/ reg clk_in;
    #/ reg clk_out;
    #/ reg rst;
    #/ wire data_in;
    #/ reg data_valid;
    #/ wire data_out;
    #/ reg [`hamming_spec.data_length-1`:0] tx_data_buffer;
    #/ reg data_in_reg;
    #/ wire is_frame_sychronized;
    #/ wire [2:0] synchronizer_state;
    #/ wire data_sync_out;
    #/ wire data_decoder_out;
    #/ initial begin
    #/    clk_in = 0;
    #/    clk_out = 1;
    #/ end
    #/ always #10 clk_in = ~clk_in;  // 20ns周期
    #/ always #5 clk_out = ~clk_out; // 10ns周期
    #/ assign data_in = data_in_reg;
    #/ // Instantiate the Hamming Encoder
    hamming_encoder_ports = {
        'clk_in' : 'clk_in',
        'clk_out' : 'clk_out',
        'rst' : 'rst',
        'data_in' : 'data_in',
        'data_valid' : 'data_valid',
        'data_out' : 'data_out',
        'data_in_ready' : 'data_in_ready'
    }
    ModuleHammingEncoder(hamming_spec=hamming_spec, PORTS = hamming_encoder_ports)
    #/ // Instantiate frame synchronizer
    sync_frame_ports = {
        'clk_out' : 'clk_out',
        'rst' : 'rst',
        'data_in' : 'data_out',
        'is_frame_sychronized' : 'is_frame_sychronized',
        'synchronizer_state' :'synchronizer_state',
        'data_sync_out':'data_sync_out'
    }
    ModuleSyncFrame(hamming_spec=hamming_spec, PORTS = sync_frame_ports)
    #/ // Instantiate the Hamming Decoder
    hamming_decoder_ports = {
        'clk_decoder_in' : 'clk_out',
        'clk_decoder_out' : 'clk_in',
        'rst' : 'rst',
        'decoder_data_valid' : 'is_frame_sychronized',
        'data_decoder_in' : 'data_sync_out',
        'data_decoder_out' : 'data_decoder_out'
    }
    ModuleDecoder(hamming_spec=hamming_spec, PORTS = hamming_decoder_ports)
    #/ task send_data;
    #/     input [`hamming_spec.data_length-1`:0] data;
    #/     integer i;
    #/     begin
    #/         for (i = `hamming_spec.data_length-1`; i >= 0; i = i - 1) begin
    #/             data_in_reg = data[i];
    #/             data_valid = 1;
    #/             @(posedge clk_in);
    #/         end
    #/         data_valid = 0;
    #/     end
    #/ endtask
    #/ initial begin
    #/     $dumpfile("wave.vcd");
    #/     $dumpvars(0, Tb0000000001);
    #/     # 5
    #/     rst = 1'b1;
    #/     # 20 rst = 1'b0;
    #/     # 20 data_valid = 1'b1;
    #/     @ (posedge clk_in);
    for i_tx_frame in range(0, hamming_spec.n_tx_frames):
        #/     send_data(`hamming_spec.data_length`'b`hamming_spec.info_bits_str[i_tx_frame]`);
        pass
    #/     # 1500 $finish;
    #/ end
    #/ integer fd;
    #/ integer fd_decoder_out;
    #/ initial begin
    #/   fd = $fopen("encoded_bits.txt", "w");
    #/   fd_decoder_out = $fopen("decoder_out_bits.txt", "w");
    #/ end
    #/ always @(posedge clk_out) begin
    #/   // $display("Time:%t Output bit: %b", $time, data_out);
    #/   $fdisplay(fd, "%b", data_out);
    #/ end
    #/ always @(posedge clk_in) begin
    #/   $fdisplay(fd_decoder_out, "%b", data_decoder_out);
    #/ end
    #/ endmodule
    pass
    
        
            
                    
folder_path = 'RTL' 
absolute_folder_path = r"D:\\ChannelCoding\\AutoGen\\Verilog\\hamming_git\\HammingEncoderDecoder\\rtl"

def clear_folder(target_dir):
    for item in os.listdir(target_dir):
        item_path = os.path.join(target_dir, item)
        if os.path.isfile(item_path):
            try:
                os.remove(item_path)
                print(f"Deleted: {item_path}")
            except Exception as e:
                print(f"Failed to delete: {item_path} - Error: {e}")
        
        # 如果是子文件夹，递归删除整个目录
        elif os.path.isdir(item_path):
            try:
                shutil.rmtree(item_path)
                print(f"Deleted sub dir: {item_path}")
            except Exception as e:
                print(f"Failed to delete: {item_path} - Error: {e}")

clear_folder(absolute_folder_path)

moduleloader.set_naming_mode('SEQUENTIAL')  
moduleloader.set_root_dir(folder_path)
moduleloader.set_debug_mode(True)
moduleloader.disEnableWarning()


my_spec = hamming_spec(flag_interleave=False)
ModuleTb(hamming_spec=my_spec)



import os

output_filename = 'hamming_tb.v'

file_list = [
    f for f in os.listdir(folder_path)
    if os.path.isfile(os.path.join(folder_path, f)) and f != output_filename
]


with open(os.path.join(folder_path, output_filename), 'w', errors='ignore') as outfile:
    for filename in file_list:
        file_path = os.path.join(folder_path, filename)
        with open(file_path, 'r', errors='ignore') as infile:
            outfile.write(f"// === Contents from: {filename} ===\n")
            outfile.write(infile.read())
            outfile.write("\n\n")  

run_iverilog_flow(absolute_folder_path)


# start validation
verilog_output_file = 'encoded_bits.txt'

# print info in blue color
print('\033[34m' + f"================Validating encoder output================" + '\033[0m')
n_failed_frames_encoding = 0
with open (os.path.join(absolute_folder_path, verilog_output_file), 'r') as f:
     encoded_bits_str = f.read()

# print(f"Encoded bits: {encoded_bits_str}")
# replace all the '\n' in encoded_bits_str with empty string
encoded_bits_str = encoded_bits_str.replace('\n', '')
# print(f"Encoded bits: {encoded_bits_str}")
# print(f"encoded_bits_part: {encoded_bits_str[70:133]}")


start_bit = 69
for i_tx_frame in range(0, my_spec.n_tx_frames):
    end_bit = start_bit + my_spec.frame_length 
    print(f"start_from: {start_bit}, end_at: {end_bit-1}")
    encoded_bits_single_frame_str = encoded_bits_str[start_bit:end_bit]
    start_bit = end_bit 
    # compare the encoded bits with expected encoded bits
    expected_encoded_bits_single_frame_str = my_spec.encoded_bits_expected_str[i_tx_frame]
    info_bits_str = my_spec.info_bits_str[i_tx_frame]
    print(f"======= Frame {i_tx_frame} ========")
    print(f"Info bits: {info_bits_str}")
    print(f"Expected encoded bits: {expected_encoded_bits_single_frame_str}")
    print(f"Encoded bits: {encoded_bits_single_frame_str}")
    # if equal, print 'pass' with green color
    # else, print 'fail' with red color
    if encoded_bits_single_frame_str == expected_encoded_bits_single_frame_str:
        print('\033[32m' + f"Pass for frame {i_tx_frame}" + '\033[0m')
    else:
        n_failed_frames_encoding += 1
        print('\033[31m' + f"Fail for frame {i_tx_frame}" + '\033[0m')
        
print('\033[34m' + f"================Validating decoder output================" + '\033[0m')
n_failed_frames_decoding = 0
start_bit = 104
verilog_decoder_output_file = 'decoder_out_bits.txt'
with open (os.path.join(absolute_folder_path, verilog_decoder_output_file), 'r') as f:
     decoder_out_bits_str = f.read()
decoded_out_bits_str = decoder_out_bits_str.replace('\n', '')
for i_tx_frame in range(1, my_spec.n_tx_frames):
    end_bit = start_bit + my_spec.data_length 
    print(f"start_from: {start_bit}, end_at: {end_bit-1}")
    decoded_bits_single_frame_str = decoded_out_bits_str[start_bit:end_bit]
    start_bit = end_bit 
    # compare the encoded bits with expected encoded bits
    expected_decoded_bits_single_frame_str = my_spec.info_bits_str[i_tx_frame]
    info_bits_str = my_spec.info_bits_str[i_tx_frame]
    print(f"======= Frame {i_tx_frame} ========")
    print(f"Info bits: {info_bits_str}")
    print(f"Expected decoded bits: {expected_decoded_bits_single_frame_str}")
    print(f"Decoded bits: {decoded_bits_single_frame_str}")
    # if equal, print 'pass' with green color
    # else, print 'fail' with red color
    if encoded_bits_single_frame_str == expected_encoded_bits_single_frame_str:
        print('\033[32m' + f"Pass for frame {i_tx_frame}" + '\033[0m')
    else:
        print('\033[31m' + f"Fail for frame {i_tx_frame}" + '\033[0m')
        n_failed_frames_decoding += 1

print('\033[34m' + f"================Validation Summary================" + '\033[0m')
if n_failed_frames_encoding == 0:
    print('\033[32m' + f"All encoding frames passed" + '\033[0m')
else:
    print('\033[31m' + f"{n_failed_frames_encoding} encoding frames failed" + '\033[0m')

if n_failed_frames_decoding == 0:
    print('\033[32m' + f"All decoding frames passed" + '\033[0m')
else:
    print('\033[31m' + f"{n_failed_frames_decoding} decoding frames failed" + '\033[0m')