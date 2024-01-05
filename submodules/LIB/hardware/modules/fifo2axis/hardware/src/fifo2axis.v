`timescale 1ns / 1ps

module fifo2axis #(
    parameter FIFO_DATA_W     = 0,
    parameter AXIS_DATA_W = DATA_W,
    parameter AXIS_LEN_W = LEN_W,
) (
`include "clk_rst_s_port.vs"
   input rst_i,
   input en_i,
   input [AXIS_LEN_W-1:0] len_i,

   // FIFO I/F
   input                    fifo_empty_i,
   input [FIFO_DATA_W-1:0]  fifo_rdata_i,
   output                   fifo_read_o,
   
   // AXIS I/F
   output                   axis_tvalid_o,
   input                    axis_tready_i,
   output [AXIS_DATA_W-1:0] axis_tdata_o,
   output                   axis_tlast_o,
   );


   //FIFO read
   wire                   axis_pc;
   reg                    axis_pc_nxt;
   always @* begin
      axis_pc_nxt = axis_pc+1'b1;
      fifo_read_o = 1'b0;

      case (axis_pc)
       axis_tvalid_o = 1'b0;
       0: begin
           if (fifo_empty_i) begin
              axis_pc_nxt = axis_pc;
           end else begin
              fifo_read_o = 1'b1;
           end
        end
        default: begin
           axis_tvalid_o = 1'b1;
           axis_pc_nxt = axis_pc;
           if (axis_tready_i) begin
              if (fifo_empty_i) begin
                 axis_pc_nxt = 1'b0;
               end else begin
                 fifo_read_o = 1'b1;
               end
           end 
        end
      endcase
   end // always @ *
   
   iob_reg_r #(
      .DATA_W (1),
      .RST_VAL(1'd0)
   ) axis_pc_reg (
`include "clk_rst_s_portmap.vs"
      .rst_i (rst_i),
      .data_i(axis_pc_nxt),
      .data_o(axis_pc)
   );

   //FIFO tlast
   wire axis_tlast_nxt;
   assign axis_tlast_nxt = (axis_word_count == len_i);

   iob_reg_re #(
      .DATA_W (1),
      .RST_VAL(1'd0)
   ) axis_pc_reg (
`include "clk_rst_s_portmap.vs"
      .rst_i (rst_i),
      .data_i(axis_tlast_nxt),
      .data_o(axis_tlast_o)
   );

   //tdata word count
   iob_counter #(
                 .DATA_W (DATA_W),
                 .RST_VAL(0)
                 ) word_count_inst (
`include "clk_rst_s_portmap.vs"
                                    .rst_i (rst_i),
                                    .en_i  (fifo_read_o),
                                    .data_o(axis_word_count)
                                    );

   
endmodule