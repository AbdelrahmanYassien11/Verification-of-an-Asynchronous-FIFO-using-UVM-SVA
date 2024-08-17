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

  logic [FIFO_WIDTH-1:0]  data_out;
  logic                   empty;
  logic                   full;


   inputs_monitor inputs_monitor_h;
   outputs_monitor outputs_monitor_h;
   STATE_e operation_interface;


	task generic_reciever(input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDTH-1:0] idata_in, input bit iw_en, input bit ir_en, input STATE_e ioperation);
      operation_interface = ioperation; 
      send_inputs(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
			if((wrst_n === 1'b0) || (rrst_n === 1'b0)) begin
         w_en = iw_en;
         r_en = ir_en;
				reset_FIFO();
      end
			else begin

      write_read_FIFO(idata_in); 

      end
	endtask : generic_reciever


	task reset_FIFO();
    if((wrst_n === 1'b0) && (rrst_n === 1'b0))begin
      fork
        read_reset();
        write_reset();
      join
      send_outputs();
      wrst_n = 1;
      rrst_n = 1;
    end
    else if ((wrst_n === 1'b0) && (rrst_n === 1'b1)) begin
      write_reset();
      send_outputs();
      wrst_n = 1;
    end
    else if ((wrst_n === 1'b1) && (rrst_n === 1'b0)) begin
      read_reset();
      send_outputs();
      rrst_n = 1;
    end
 	endtask : reset_FIFO

  task read_reset();
    rrst_n = 0;
    @(negedge rclk);
  endtask : read_reset

  task write_reset();
    wrst_n = 0;
    @(negedge wclk);
  endtask : write_reset


  task write_read_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
    if((w_en === 1'b1) && (r_en === 1'b1))begin
      fork
        read_FIFO();
        write_FIFO(idata_in);
      join
      send_outputs();
      w_en = 0;
      r_en = 0;
    end
    else if ((w_en === 1'b1) && (r_en === 1'b0)) begin
      write_FIFO(idata_in);
      send_outputs();
      w_en = 0;
    end
    else if ((w_en === 1'b0) && (r_en === 1'b1)) begin
      read_FIFO();
      send_outputs();
      r_en = 0;
    end
  endtask : write_read_FIFO


 	task write_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
 		@(negedge wclk);
      wrst_n = 1'b1;
 			w_en = 1'b1;
 			data_in = idata_in;
 		@(negedge wclk);
	endtask : write_FIFO


 	task read_FIFO();
 		@(negedge rclk);
      rrst_n = 1'b1;
  		r_en = 1'b1;
 		@(negedge rclk);
 	endtask : read_FIFO


  // property full_p;
  //   @(negedge wclk) FIFO_full |-> (($rose(full) until_with (!FIFO_full));
  // endproperty

  // full_check: assert (full_p);


   function void send_inputs(input bit irrst_n, input bit iwrst_n, input bit [31:0] idata_in, input bit iw_en, input bit ir_en);
      inputs_monitor_h.write_to_monitor(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
   endfunction : send_inputs

   function void send_outputs();
   		outputs_monitor_h.write_to_monitor(rrst_n, wrst_n, data_in, w_en, r_en, data_out, empty, full, operation_interface);
   endfunction : send_outputs

  // assign FIFO_full = (((wrap_around) ^ (write_pointer === read_pointer)) === 0);
  // assign FIFO_empy = (write_pointer === read_pointer);
  

endinterface : inf



  // clocking cb_w @(negedge clk);
  //   default input #CYCLE_WRITE/2 output;
  //   input full;
  //   output [FIFO_WIDTH-1:0] data_in;
  //   output wrst_n, w_en;
  // endclocking


  // clocking cb_r @(negedge clk);
  //   default input #CYCLE_READ/2 output #2;

  //   input  [FIFO_WIDTH-1:0] data_out;
  //   input empty;

  //   output rrst_n, r_en;
  // endclocking


  // assign data_out = cb_r.data_out;

  // assign empty    = cb_r.empty;
  // assign full     = cb_w.full;

  // assign cb_w.data_in = data_in;

  // assign rrst_n    = cb_r.rrst_n;
  // assign r_en     = cb_r.r_en;

  // assign wrst_n    = cb_w.wrst_n;
  // assign w_en     = cb_w.w_en;