interface inf (
    input bit wclk,
    input bit rclk
    );

import FIFO_pkg::*;
    
  bit                     rrst_n;
  bit                     wrst_n;
  bit   [FIFO_WIDTH-1:0]  data_in;
  bit                     w_en;
  bit                     r_en;
  bit   

  logic [FIFO_WIDTH-1:0]  data_out;
  logic                   empty;
  logic                   full;

  clocking cb_w @(negedge clk);
    default input #CYCLE_WRITE/2 output;
    input full;
    output [FIFO_WIDTH-1:0] data_in;
    output wrst_n, w_en;
  endclocking


  clocking cb_r @(negedge clk);
    default input #CYCLE_READ/2 output #2;

    input  [FIFO_WIDTH-1:0] data_out;
    input empty;

    output rrst_n, r_en;
  endclocking


  assign data_out = cb_r.data_out;

  assign empty    = cb_r.empty;
  assign full     = cb_w.full;

  assign cb_w.data_in = data_in;

  assign rrst_n    = cb_r.rrst_n;
  assign r_en     = cb_r.r_en;

  assign wrst_n    = cb_w.wrst_n;
  assign w_en     = cb_w.w_en;




   inputs_monitor inputs_monitor_h;
   outputs_monitor outputs_monitor_h;
   STATE_e operation_interface;


	task generic_reciever(input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDHT-1:0] idata_in, input bit iw_en, input bit ir_en, input STATE_e ioperation);
      operation_interface = ioperation; 
      send_inputs(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
			if(irst_n === 1'b0) begin
        // w_en = iw_en;
        // r_en = ir_en;
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
      rst_n = 1'b0;
 		@(negedge clk);
 		 send_outputs();
 		 rst_n = 1'b1;
 	endtask : reset_FIFO

  task wr_reset();
    ##1;
    wrst_n = 0;
    ##1;
    wrst_n = 1;
  endtask : wr_reset

  task rd_reset();
    ##1;
    rrst_n = 0;
    ##1;
    rrst_n = 1;
  endtask : rd_reset


 	task write_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
 		@(negedge clk);
      rst_n = 1'b1;
 			wr_en = 1'b1;
      rd_en = 1'b0;
 			data_in = idata_in;
 		@(negedge clk);
 			send_outputs();
      wr_en = 1'b0;
	 endtask : write_FIFO


 	task read_FIFO();
 		@(negedge clk);
      rst_n = 1'b1;
      wr_en = 1'b0;
  		rd_en = 1'b1;
 		@(negedge clk);
 			send_outputs();
      rd_en = 1'b0;
 	endtask : read_FIFO

   function void send_inputs(input bit irst_n, input bit [31:0] idata_in, input bit iwr_en, input bit ird_en);
      inputs_monitor_h.write_to_monitor(irst_n, idata_in, iwr_en, ird_en);
   endfunction : send_inputs

   function void send_outputs();
   		outputs_monitor_h.write_to_monitor(rst_n, data_in, wr_en, rd_en, data_out, 
                                         wr_ack, overflow, underflow, almostempty, empty, almostfull, full,
                                         half_full, operation_interface);
   endfunction : send_outputs






endinterface : inf


