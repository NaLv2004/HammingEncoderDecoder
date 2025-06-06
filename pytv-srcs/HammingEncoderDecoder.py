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
from utils import gather_file_and_write
from hamming_spec import hamming_spec
from Encode import ModuleHammingEncoder
from Decode import ModuleDecoder
from Sync import ModuleSyncFrame
from PN import ModulePNGenerator
from Tb import ModuleTb
from validate import validate_encoder_decoder

            
# ==============================================PATH OF GENERATED RTL CODE==============================================               
folder_path = 'rtl' 
# obtain current working directory
current_dir =os.getcwd()
if not 'HammingEncoderDecoder' in current_dir:
    raise Exception("Please run this script from the HammingEncoderDecoder directory. Otherwise, operation will not continue for fear that your own files are deleted.")
# join the current directory with the folder path
absolute_folder_path = os.path.join(current_dir, folder_path)
# absolute_folder_path = r"D:\\ChannelCoding\\AutoGen\\Verilog\\hamming_git\\HammingEncoderDecoder\\rtl"
moduleloader.set_naming_mode('SEQUENTIAL')  
moduleloader.set_root_dir(folder_path)
moduleloader.set_debug_mode(True)
moduleloader.disEnableWarning()
clear_folder(absolute_folder_path)

# ==============================================HAMMING CODE SPECIFICATIONS===============================================
# # 31PN
# my_spec = hamming_spec(
# flag_interleave=False, 
# bit_sequence_generator='PN' ,
# pn_generator_coeff=[1,0,1,0,0,1] , # polynomial: x^5 + x^2 + 1
# pn_generator_initial_state='10110',
# frame_head_error_pos=[],
# forward_false_frame_cnt=1,
# backward_correct_frame_cnt=1
# )

# # 15PN
# my_spec = hamming_spec(
# flag_interleave=False, 
# bit_sequence_generator='PN' ,
# pn_generator_coeff=[1,0,0,1,1] ,
# pn_generator_initial_state='1011'
# )


# random bits
my_spec = hamming_spec(
flag_interleave=False, 
bit_sequence_generator='random' ,
pn_generator_coeff=[1,0,0,1,1] ,
pn_generator_initial_state='1011'
)

# ==============================================GENERATE VERILOG CODE===============================================
ModuleTb(hamming_spec=my_spec)
# ModulePNGenerator(hamming_spec=my_spec)



# ==============================================COMPILE AND RUN VERILOG CODE===============================================
output_filename = 'hamming_tb.v'
gather_file_and_write(folder_path, output_filename)
run_iverilog_flow(absolute_folder_path)


# ==============================================VALIDATE ENCODER AND DECODER OUTPUT================================================
# start validation
verilog_output_file = 'encoded_bits.txt'
start_bit = 69

validate_encoder_decoder(my_spec=my_spec, verilog_output_file=verilog_output_file, start_bit=start_bit, absolute_folder_path=absolute_folder_path)

