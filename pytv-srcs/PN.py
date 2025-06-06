from pytv import convert
from pytv import moduleloader
import math

@ convert
def ModulePNGenerator(hamming_spec):
    #/ module PNGenerator(
    #/     input clk,
    #/     input rst,
    #/     input en,
    #/     output pn_out
    #/ );
    n_shift_registers = len(hamming_spec.pn_generator_coeff)-1
    #/ wire clk;
    #/ wire rst;
    #/ wire en;
    #/ wire pn_out;
    for i in range(0,n_shift_registers):
        #/ reg pn_reg_`i`;
        pass
    #/ assign pn_out = pn_reg_0;
    #/ always @ (posedge clk or posedge rst)
    #/ begin
    #/     if (rst) begin
    for i in range(0, n_shift_registers):
        #/         pn_reg_`i` <= 1'b`hamming_spec.pn_generator_initial_state[i]`;
        pass
    #/     end else begin
    #/         if (en) begin
    for i in range(0, n_shift_registers-1):
        #/             pn_reg_`i` <= pn_reg_`i+1` ;
        pass
    #/             pn_reg_`n_shift_registers-1` <= 
    for i in range(0, n_shift_registers):
        if hamming_spec.pn_generator_coeff[i+1] == 1:
            #/                 (pn_reg_`n_shift_registers-1-i` ^ 1'b0) ^
            pass
        else:
            #/                 (pn_reg_`n_shift_registers-1-i` & 1'b0) ^
            pass
    pass
    #/                 1'b0;
    #/         end
    #/     end
    #/ end
    #/ endmodule
    pass
    