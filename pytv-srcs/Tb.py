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
from utils import run_iverilog_flow
from utils import clear_folder
from hamming_spec import hamming_spec
from Encode import ModuleHammingEncoder
from Decode import ModuleDecoder
from Sync import ModuleSyncFrame
from PN import ModulePNGenerator
from PN import ModuleRepetitiveBitSeqGenerator


@ convert 
def ModuleTb(hamming_spec:hamming_spec):
    is_in_frame_error = len(hamming_spec.in_frame_error_pos) > 0
    #/ module Tb();
    #/ reg clk_in;
    #/ reg clk_out;
    #/ reg rst;
    #/ wire data_in;
    #/ reg data_valid;
    #/ wire data_out;
    #/ wire data_out_error;
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
    if hamming_spec.bit_sequence_generator == 'random':
       #/ assign data_in = data_in_reg;
       pass
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
    if is_in_frame_error:
        hamming_encoder_ports['data_out_error'] = 'data_out_error'
    ModuleHammingEncoder(hamming_spec=hamming_spec, PORTS = hamming_encoder_ports)
    #/ // Instantiate frame synchronizer
    sync_frame_ports = {
        'clk_out' : 'clk_out',
        'rst' : 'rst',
        'is_frame_sychronized' : 'is_frame_sychronized',
        'synchronizer_state' :'synchronizer_state',
        'data_sync_out':'data_sync_out'
    }
    if is_in_frame_error:
        sync_frame_ports['data_in'] = 'data_out_error'
    else:
        sync_frame_ports['data_in'] = 'data_out'
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
    if hamming_spec.bit_sequence_generator == 'PN':
        pn_generator_ports = {
            'clk' : 'clk_in',
            'rst' : 'rst',
            'en' : 'data_valid',
            'pn_out' : 'data_in'
        }
        ModulePNGenerator(hamming_spec=hamming_spec, PORTS = pn_generator_ports)
    if hamming_spec.bit_sequence_generator == 'RepetitiveSeq':
        repetitive_bit_seq_generator_ports = {
            'clk' : 'clk_in',
            'rst' : 'rst',
            'en' : 'data_valid',
            'pn_out' : 'data_in'
        }
        ModuleRepetitiveBitSeqGenerator(hamming_spec=hamming_spec, PORTS = repetitive_bit_seq_generator_ports)
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
    if hamming_spec.bit_sequence_generator == 'random':
        for i_tx_frame in range(0, hamming_spec.n_tx_frames):
            #/     send_data(`hamming_spec.data_length`'b`hamming_spec.info_bits_str[i_tx_frame]`);
            pass
    #/     # 15000 $finish;
    #/ end
    #/ integer fd;
    #/ integer fd_decoder_out;
    #/ integer fd_pn_out;
    #/ integer fd_error_out;
    #/ initial begin
    #/   fd = $fopen("encoded_bits.txt", "w");
    #/   fd_decoder_out = $fopen("decoder_out_bits.txt", "w");
    #/   fd_pn_out = $fopen("pn_out_bits.txt", "w");
    #/   fd_error_out = $fopen("error_out_bits.txt", "w");
    #/ end
    #/ always @(posedge clk_out) begin
    #/   // $display("Time:%t Output bit: %b", $time, data_out);
    #/   $fdisplay(fd, "%b", data_out);
    #/ end
    #/ always @(posedge clk_in) begin
    #/   $fdisplay(fd_decoder_out, "%b", data_decoder_out);
    #/ end
    if is_in_frame_error:
        #/ always @(posedge clk_out) begin
        #/   $fdisplay(fd_error_out, "%b", data_out_error);
        #/ end
        pass
    if hamming_spec.bit_sequence_generator == 'PN':
        #/ always @(posedge clk_in) begin
        #/   $fdisplay(fd_pn_out, "%b", data_in);
        #/ end
        pass
    #/ endmodule
    pass
    