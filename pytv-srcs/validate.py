import os
from hamming_spec import hamming_spec
def validate_encoder_decoder(my_spec:hamming_spec, absolute_folder_path, verilog_output_file, start_bit=69):
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


    start_bit = start_bit
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
        if decoded_bits_single_frame_str == expected_decoded_bits_single_frame_str:
            print('\033[32m' + f"Pass for frame {i_tx_frame}" + '\033[0m')
        else:
            print('\033[31m' + f"Fail for frame {i_tx_frame}" + '\033[0m')
            n_failed_frames_decoding += 1

    print('\033[34m' + f"================Validation Summary================" + '\033[0m')
    if n_failed_frames_encoding == 0:
        print('\033[32m' + f"All frames passed encoding validation" + '\033[0m')
    else:
        print('\033[31m' + f"{n_failed_frames_encoding} encoding frames failed" + '\033[0m')

    if n_failed_frames_decoding == 0:
        print('\033[32m' + f"All frames passed decoding validation" + '\033[0m')
    else:
        print('\033[31m' + f"{n_failed_frames_decoding} decoding frames failed" + '\033[0m')