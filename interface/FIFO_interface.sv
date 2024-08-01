interface inf (
    input logic clk
    );

import FIFO_pkg::*;
    
  bit                     rst_n;
  bit   [FIFO_WIDTH-1:0]  data_in;
  bit                     wr_en;
  bit                     rd_en;

  logic [FIFO_WIDTH-1:0]  data_out;
  logic                   wr_ack;
  logic                   overflow;
  logic                   underflow;
  logic                   almostempty;
  logic                   empty;
  logic                   almostfull;
  logic                   full;
  logic                   half_full;

  modport DUT (input clk, rst_n, data_in, wr_en, rd_en, output wr_ack, overflow, underflow, almostempty, empty, almostfull, full, half_full, data_out );
  //modport TEST (input wr_ack, overflow, underflow, almostempty, empty, almostfull, full, half_full, data_out, output clk, rst_n, data_in, wr_en, rd_en);
  //modport MONITOR (input wr_ack, overflow, underflow, almostempty, empty, almostfull, full, half_full, data_out, clk, rst_n, data_in, wr_en, rd_en);
  modport SVA (input wr_ack, overflow, underflow, almostempty, empty, almostfull, full, half_full, data_out ,  clk, rst_n, data_in, wr_en, rd_en);


	task generic_reciever(input bit irst_n, input bit [31:0] idata_in, input bit iwr_en, input bit ird_en);
      send_inputs();
			if(irst_n === 1'b1) begin
				reset_FIFO();
			end
			else if(iwr_en === 1'b1 && ird_en === 1'b0) begin
				write_FIFO(idata_in);
			end
			else if(iwr_en === 1'b0 && ird_en === 1'b1) begin
				read_FIFO();
			end
	endtask : generic_reciever


	task reset_FIFO();
 		@(negedge clk);
      rst_n = 1'b1;
 		@(negedge clk);
 		 send_outputs();
 		 rst_n = 1'b0;
 	endtask : reset_FIFO



 	task write_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
 		@(negedge clk);
 			wr_en = 1'b1;
 			data_in = idata_in;
 		@(negedge clk);
 			send_outputs();
      wr_en = 1'b0;
	 endtask : write_FIFO


 	task read_FIFO();
 		@(negedge clk);
  		rd_en = 1'b0;
 		@(negedge clk);
 			send_outputs();
      rd_en = 1'b0;
 	endtask : read_FIFO

   inputs_monitor inputs_monitor_h;
   outputs_monitor outputs_monitor_h;

   function void send_inputs();
      inputs_monitor_h.write_to_monitor(rst_n, data_in, wr_en, rd_en);
   endfunction : send_inputs

   function void send_outputs();
   		outputs_monitor_h.write_to_monitor(rst_n, data_in, wr_en, rd_en, data_out, 
                                         wr_ack, overflow, underflow, almostempty, empty, almostfull, full,
                                         half_full);
   endfunction : send_outputs

endinterface : inf


