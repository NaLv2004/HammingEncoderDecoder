import math
import random
class hamming_spec:
    def __init__(self, flag_interleave=False, frame_head_error_pos=[] ,forward_false_frame_cnt=3, backward_correct_frame_cnt=1, bit_sequence_generator='random', pn_generator_coeff=[], pn_generator_initial_state='1101'):
        self.code_length = 7
        self.info_length = 4
        self.frame_head_length = 8
        self.n_info_groups = 2
        self.group_length = 16
        self.n_tx_frames = 20
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
        # bit sequence generator parameters
        self.bit_sequence_generator = bit_sequence_generator  # 'random' or 'PN'
        self.pn_generator_coeff = pn_generator_coeff
        self.pn_generator_initial_state = pn_generator_initial_state
        # synchronization parameters
        self.backward_frame_head_error = 0   # Allowed bit errors in frame head during backward protection
        self.backward_correct_frame_cnt = backward_correct_frame_cnt  # Number of correct frames during backward protection to enter sync state
        self.capture_error = 0               # Allowed errors in frame head to remain in sync state
        self.forward_false_frame_cnt = forward_false_frame_cnt   # Number of false frames during forward protection to re-enter capture state
        self.backward_correct_frame_cnt_width = math.ceil(math.log2(self.backward_correct_frame_cnt+1)) + 1
        self.forward_false_frame_cnt_width = math.ceil(math.log2(self.forward_false_frame_cnt+1)) + 1
        # Set errors in frame head and transmitted bits
        self.frame_head_errors = frame_head_error_pos   # frames with error in frame head  e.g. frame_head_errors = [1,5,6,7]
        self.generate_info_bits()
        self.generate_encoded_bits_expected()
        print(f"info_bits:")
        print(f"{self.info_bits_str}")
        print(f"encoded_bits:")
        print(f"{self.encoded_bits_expected_str}")
        
        
    def generate_pn_sequence(self, pn_coeff, pn_initial_state, L):
        pn_register = [int(x) for x in pn_initial_state]
        pn_coefficients = [int(x) for x in pn_coeff]
        pn_sequence = []
        n_pn_registers = len(pn_register)
        for i in range(0, L):
            print(f"pn_register:{pn_register}")
            pn_sequence.append(pn_register[0])
            pn_register_renew = 0
            for j in range(1, n_pn_registers+1):
                pn_register_renew ^= (pn_coefficients[j]&pn_register[n_pn_registers-j])
            for j in range(0, n_pn_registers-1):
                pn_register[j] = pn_register[j+1]
            pn_register[n_pn_registers-1] = pn_register_renew
        return pn_sequence
       
        
    def generate_info_bits(self):
        if self.bit_sequence_generator == 'random':
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
        elif self.bit_sequence_generator == 'PN':
            if (len(self.pn_generator_coeff)!= len(self.pn_generator_initial_state)+1):
                raise ValueError("The length of pn_generator_coeff should be one more than the length of pn_generator_initial_state")
            L = self.n_tx_frames * self.data_length + 100
            pn_sequence = self.generate_pn_sequence(self.pn_generator_coeff, self.pn_generator_initial_state, L)
            print(f"pn_sequence:{pn_sequence[0:100]}")
            start_bit = 0
            for i in range(0, self.n_tx_frames):
                end_bit = start_bit + self.data_length
                info_bits_single_frame = pn_sequence[start_bit:end_bit]
                info_bits_single_frame_str = "".join([str(x) for x in info_bits_single_frame])
                self.info_bits.append(info_bits_single_frame)
                self.info_bits_str.append(info_bits_single_frame_str)
                start_bit = end_bit
                
                

        
            
            
    def generate_encoded_bits_expected(self):
        for i in range(0, self.n_tx_frames):
            encoded_bits_single_frame = []
            encoded_bits_single_frame_str = ""
            # frame head
            encoded_bits_single_frame += [0,1,1,1,1,1,1,0]
            if (i in self.frame_head_errors) :
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
                encoded_bits_single_frame_reverse = encoded_bits_single_frame[::-1]
                encoded_bits_single_frame_reverse_interleaved = encoded_bits_single_frame_reverse.copy()
                # interleave the bits
                n_codewords = self.n_info_groups*math.ceil(self.group_length/self.info_length)
                for i_codeword in range(0, n_codewords):
                    for j_bit in range(0, self.code_length):
                        encoded_bits_single_frame_reverse_interleaved[j_bit*n_codewords+i_codeword] = encoded_bits_single_frame_reverse[i_codeword*self.code_length+j_bit]           
                encoded_bits_single_frame = encoded_bits_single_frame_reverse_interleaved[::-1]
                encoded_bits_single_frame_str = ""
                for i_bit in range(0, self.frame_length):
                    encoded_bits_single_frame_str += str(encoded_bits_single_frame[i_bit])
                        
            self.encoded_bits_expected.append(encoded_bits_single_frame)
            self.encoded_bits_expected_str.append(encoded_bits_single_frame_str)
