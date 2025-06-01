 module HammingEncoder0000000001 (
     input clk_in,
     input clk_out,
     input rst,
     input data_in,
     input data_valid,
     output data_out,
     output data_in_ready
 );
 wire clk_in;
 wire clk_out;
 wire rst;
 wire data_in;
 wire data_valid;
 wire data_out;
 wire data_in_ready;
 wire frame_ready_wire;
 reg input_bit_reg;
 reg [63:0] tx_frame_buffer;
 reg [31:0] input_data_buffer;
 reg [5:0] input_counter_reg;
 reg [6:0] output_counter_reg;
 reg [5:0] input_counter_reg_prev;
 reg [5:0] input_counter_reg_delayed_clkout_1;
 reg [5:0] input_counter_reg_delayed_clkout_2;
 reg [5:0] input_counter_reg_delayed_clkout_3;
 wire [5:0] input_write_idx;
 wire [6:0] output_read_idx;
 wire [63:0] tx_frame_wire;
 wire [31:0] input_data_wire;
 reg [8:0] n_frames_sent;
 reg frame_ready;
 reg encoder_ready;
 reg data_buffer_ready;
 reg data_out_reg;
 assign data_out = data_out_reg;
 assign data_in_ready = data_buffer_ready;
 // the higher bits are transmitted first
 assign input_data_wire = input_data_buffer;
 assign frame_ready_wire = ((input_counter_reg_delayed_clkout_1 == 31) && (input_counter_reg==0))? 1 : 0;
 assign input_write_idx =6'd 31-input_counter_reg;
 assign output_read_idx =7'd 63-output_counter_reg;
 // frame head for synchronization
 assign tx_frame_wire[63:56] =
     (n_frames_sent == 5) ? 8'b01101110 :
     (n_frames_sent == 6) ? 8'b01101110 :
     (n_frames_sent == 7) ? 8'b01101110 :
     8'b01111110;
 // assign encoding input to data input buffer,  assign tx_frame_wire to encoding output
 // instantiate single encoder for each group of data
SingleEncoder0000000001  u_0000000001_SingleEncoder0000000001(.data_in(input_data_wire[3:0]), .data_out(tx_frame_wire[6:0]));
SingleEncoder0000000001  u_0000000002_SingleEncoder0000000001(.data_in(input_data_wire[7:4]), .data_out(tx_frame_wire[13:7]));
SingleEncoder0000000001  u_0000000003_SingleEncoder0000000001(.data_in(input_data_wire[11:8]), .data_out(tx_frame_wire[20:14]));
SingleEncoder0000000001  u_0000000004_SingleEncoder0000000001(.data_in(input_data_wire[15:12]), .data_out(tx_frame_wire[27:21]));
SingleEncoder0000000001  u_0000000005_SingleEncoder0000000001(.data_in(input_data_wire[19:16]), .data_out(tx_frame_wire[34:28]));
SingleEncoder0000000001  u_0000000006_SingleEncoder0000000001(.data_in(input_data_wire[23:20]), .data_out(tx_frame_wire[41:35]));
SingleEncoder0000000001  u_0000000007_SingleEncoder0000000001(.data_in(input_data_wire[27:24]), .data_out(tx_frame_wire[48:42]));
SingleEncoder0000000001  u_0000000008_SingleEncoder0000000001(.data_in(input_data_wire[31:28]), .data_out(tx_frame_wire[55:49]));
 always @ (posedge clk_in or posedge rst)
 begin
 input_counter_reg_prev <= input_counter_reg;
     if (rst) begin
         tx_frame_buffer <= 64'b0;
         input_data_buffer <= 32'b0;
         input_counter_reg <= 6'b0;
         output_counter_reg <= 7'b0;
         input_bit_reg <= 1'b0;
         frame_ready <= 0;
         data_out_reg <= 0;
         encoder_ready <= 1'b1;
         data_buffer_ready <= 1'b1;
         n_frames_sent <= 0;
     end  else begin
         if (data_valid ) begin
             input_data_buffer[input_write_idx] <= data_in;
             input_counter_reg <= input_counter_reg + 1;
             data_buffer_ready <= 1'b0;
             input_bit_reg <= data_in;
          end
         if (input_counter_reg == 31) begin // input_counter_reg_prev == 31
             // frame_ready <= 1'b1;
             input_counter_reg <= 0;
             data_buffer_ready <= 1'b1;
             encoder_ready <= 1'b0;
         end
     end
 end
 // output data with twice the rate of input data
 always @ (posedge clk_out or posedge rst)
 begin
     input_counter_reg_delayed_clkout_1 <= input_counter_reg;
     input_counter_reg_delayed_clkout_2 <= input_counter_reg_delayed_clkout_1;
     input_counter_reg_delayed_clkout_3 <= input_counter_reg_delayed_clkout_2;
     if (frame_ready_wire) begin
          frame_ready <= 1'b1;
             tx_frame_buffer <= tx_frame_wire;
          n_frames_sent <= n_frames_sent + 1;
     end
     if (frame_ready) begin
         output_counter_reg <= output_counter_reg + 1;
         data_out_reg <= tx_frame_buffer[output_read_idx];

        // encoder_ready <= 1'b0;
     end
     if (output_counter_reg == 63) begin
         encoder_ready <= 1'b1;
         output_counter_reg <= 1'b0;
        // frame_ready <= 0;
     end

 end
 endmodule
