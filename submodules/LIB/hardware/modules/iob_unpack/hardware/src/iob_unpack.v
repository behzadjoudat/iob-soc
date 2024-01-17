`timescale 1ns / 1ps

module iob_unpack #(
   parameter DATA_W   = 21
) (
`include "clk_en_rst_s_port.vs"

   input                    rst_i,
   input                    wrap_i,
   input [$clog2(DATA_W):0] width_i,

   //read packed data to be unpacked
   output                   read_o,
   input                    rready_i,
   input [DATA_W-1:0]       rdata_i,

   //write unpacked data
   output                   write_o,
   input                    wready_i,
   output [DATA_W-1:0]      wdata_o
);

   //bfifo size
   localparam BFIFO_REG_W = 2*DATA_W;

   //input fifo read
   reg                               read;
   
   //bit fifo control
   wire [$clog2(BFIFO_REG_W):0]      push_level;
   wire [$clog2(DATA_W):0]           push_width;
   reg [$clog2(DATA_W):0]            push_width_nxt;
   reg                               push;

   wire [$clog2(BFIFO_REG_W):0]      pop_level;
   reg                               pop;
   
   //wrap control accumulator
   reg [  $clog2(DATA_W):0]          wrap_acc_nxt;
   wire [$clog2(DATA_W):0]           wrap_acc;

   //program counter
   wire [1:0]                        pcnt;
   reg [1:0]                         pcnt_nxt;
   
   //read unpacked data from external input fifo
   assign read_o = read;
   //write packed data to external output fifo
   assign write_o = pop;
   
   //control logic  
   always @* begin
      //defaults
      pop           = 1'b0;
      push          = 1'b0;
      read          = 1'b0;
      wrap_acc_nxt  = wrap_acc;
      pcnt_nxt      = pcnt + 1'b1;
      push_width_nxt = push_width;
      
      case (pcnt)
        0: begin  //compute push width
           if (!wrap_i) begin
              push_width_nxt = DATA_W;
           end else if (wrap_acc < (DATA_W - width_i)) begin
              pcnt_nxt = pcnt;
              wrap_acc_nxt = wrap_acc + width_i;
           end else begin
              push_width_nxt = wrap_acc + width_i;
           end
        end
        1:begin //wait to read data from input fifo
           if (!rready_i || (push_level < push_width)) begin
              pcnt_nxt = 2'd3;
           end else begin 
              read = 1'b1;
           end
        end
        2: begin //push data to bit fifo
           push = 1'b1;
        end
        3: begin //wait to pop data from bit fifo
           if (pop_level >= width_i && wready_i) begin
              pop = 1'b1;
           end
           pcnt_nxt = 2'd1;
         end
      endcase
   end
   
   //bit fifo
   iob_bfifo #(
      .WDATA_W(DATA_W),
      .RDATA_W(DATA_W),
      .REG_W  (BFIFO_REG_W)
   ) bfifo (
      `include "clk_en_rst_s_s_portmap.vs"
      .rst_i    (rst_i),
      //push packed data to be unpacked
      .write_i  (push),
      .wwidth_i (push_width),
      .wdata_i  (rdata_i),
      .wlevel_o (push_level),
      //pop unpacked data to be output
      .read_i   (pop),
      .rwidth_i (width_i),
      .rdata_o  (wdata_o),
      .rlevel_o (pop_level)
   );

   //wrap control accumulator
   iob_reg_r #(
      .DATA_W ($clog2(DATA_W)+1),
      .RST_VAL({$clog2(DATA_W)+1{1'b0}})
   ) wrap_acc_reg (
      `include "clk_en_rst_s_s_portmap.vs"
      .rst_i (rst_i),
      .data_i(wrap_acc_nxt),
      .data_o(wrap_acc)
   );

   //pcnt register (state counter)
   iob_reg_r #(
      .DATA_W (2),
      .RST_VAL(2'b0)
   ) pcnt_reg (
      `include "clk_en_rst_s_s_portmap.vs"
      .rst_i (rst_i),
      .data_i(pcnt_nxt),
      .data_o(pcnt)
   );

   //push width register
   iob_reg_r #(
      .DATA_W ($clog2(DATA_W)+1),
      .RST_VAL({$clog2(DATA_W)+1{1'b0}})
   ) push_width_reg (
      `include "clk_en_rst_s_s_portmap.vs"
      .rst_i (rst_i),
      .data_i(push_width_nxt),
      .data_o(push_width)
   );
   
endmodule


