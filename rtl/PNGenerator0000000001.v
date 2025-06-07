 module PNGenerator0000000001 (
     input clk,
     input rst,
     input en,
     output pn_out
 );
 wire clk;
 wire rst;
 wire en;
 wire pn_out;
 reg pn_reg_0;
 reg pn_reg_1;
 reg pn_reg_2;
 reg pn_reg_3;
 reg pn_reg_4;
 assign pn_out = pn_reg_0;
 always @ (posedge clk or posedge rst)
 begin
     if (rst) begin
         pn_reg_0 <= 1'b1;
         pn_reg_1 <= 1'b0;
         pn_reg_2 <= 1'b1;
         pn_reg_3 <= 1'b1;
         pn_reg_4 <= 1'b0;
     end else begin
         if (en) begin
             pn_reg_0 <= pn_reg_1 ;
             pn_reg_1 <= pn_reg_2 ;
             pn_reg_2 <= pn_reg_3 ;
             pn_reg_3 <= pn_reg_4 ;
             pn_reg_4 <=
                 (pn_reg_4 & 1'b0) ^
                 (pn_reg_3 ^ 1'b0) ^
                 (pn_reg_2 & 1'b0) ^
                 (pn_reg_1 & 1'b0) ^
                 (pn_reg_0 ^ 1'b0) ^
                 1'b0;
         end
     end
 end
 endmodule
