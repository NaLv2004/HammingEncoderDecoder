 module SingleEncoder0000000001 (
     input  [4-1:0] data_in,
     output [7-1:0] data_out
 );
 wire [4-1:0] data_in;
 wire [7-1:0] data_out;
 assign data_out[6] = data_in[3];  // a6
 assign data_out[5] = data_in[2];  // a5
 assign data_out[4] = data_in[1];  // a4
 assign data_out[3] = data_in[0];  // a3
 assign data_out[2] = data_in[3] ^ data_in[2] ^ data_in[1];  // a2
 assign data_out[1] = data_in[3] ^ data_in[2] ^ data_in[0];  // a1
 assign data_out[0] = data_in[3] ^ data_in[1] ^ data_in[0];  // a0
 endmodule
