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

   bit [FIFO_SIZE-1:0] write_pointer, read_pointer;
   bit wrap_around;
   logic FIFO_full, FIFO_empty;
   int incorrect_counter;
   int correct_counter;
  // bit full_covered, empty_covered;


	task generic_reciever(input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDTH-1:0] idata_in, input bit iw_en, input bit ir_en, input STATE_e ioperation);
      operation_interface = ioperation; 
      send_inputs(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
      wrst_n = iwrst_n;
      rrst_n = irrst_n;

			if((wrst_n === 1'b0) || (rrst_n === 1'b0)) begin
				reset_FIFO();
      end
			else begin
      $display("ABOUT TO ENTER WRITE_READ_FIFO ");
      write_read_FIFO(idata_in, ir_en, iw_en); 
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
    read_pointer = 0;
    rrst_n = 0;
    @(negedge rclk);
  endtask : read_reset

  task write_reset();
    read_pointer = 0;
    wrst_n = 0;
    @(negedge wclk);
  endtask : write_reset


  task write_read_FIFO(input bit [FIFO_WIDTH-1:0] idata_in, input bit ir_en, iw_en);
    $display("ENTERED WRITE_READ_FIFO ");
    if((iw_en === 1'b1) && (ir_en === 1'b1))begin
      fork
        read_FIFO();
        write_FIFO(idata_in);
      join
      send_outputs();
      w_en = 0;
      r_en = 0;
    end
    else if ((iw_en === 1'b1) && (ir_en === 1'b0)) begin
      $display("ABOUT TO ENTER WRITE_FIFO ");
      write_FIFO(idata_in);
      send_outputs();
      w_en = 0;
    end
    else if ((iw_en === 1'b0) && (ir_en === 1'b1)) begin
      read_FIFO();
      send_outputs();
      r_en = 0;
    end
  endtask : write_read_FIFO


 	task write_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
    $display("ENTERED WRITE FIFO");
 		@(negedge wclk);
      wrst_n = 1'b1;
 			w_en = 1'b1;
 			data_in = idata_in;
 		@(negedge wclk);
    if(!FIFO_full) begin
      if(write_pointer === FIFO_SIZE-1) begin
        write_pointer = 0;
        wrap_around = 1;
      end
      else begin
        write_pointer = write_pointer +1;
      end
    end
	endtask : write_FIFO


 	task read_FIFO();
 		@(negedge rclk);
      rrst_n = 1'b1;
  		r_en = 1'b1;
 		@(negedge rclk);
    read_pointer = read_pointer +1;
 	endtask : read_FIFO


   property full_p;
    @(negedge wclk)
    if(rrst_n && wrst_n)
      (FIFO_full) |-> (full) throughout (FIFO_full) ##[2:3] $fell(full);
    endproperty


  assert property (full_p) else begin
        incorrect_counter = incorrect_counter +1;
        $display("full flag asserted and deasserted INCORRECTLY");
      end
  cover property (full_p);



  // property empty_p;
  //   @(negedge rclk)
  //   if(rrst_n && wrst_n)
  //     (FIFO_empty) |-> (empty throughout !FIFO_empty) ##[2:3] (!empty); /*((empty)  until (!FIFO_empty ##1 $fell(empty)) ##[1:2] $fell(empty));*/
  // endproperty


  property empty_p;
    @(negedge rclk)
    if(rrst_n && wrst_n)
      (FIFO_empty) |-> (empty throughout FIFO_empty) ##[2:3] $fell(empty); /*((empty)  until (!FIFO_empty ##1 $fell(empty)) ##[1:2] $fell(empty));*/
  endproperty

  assert property (empty_p) else begin
        incorrect_counter = incorrect_counter +1;
        $display("time: %0t empty flag asserted and deasserted INCORRECTLY", $time());
      end
  cover property (empty_p);


   function void send_inputs(input bit irrst_n, input bit iwrst_n, input bit [31:0] idata_in, input bit iw_en, input bit ir_en);
      inputs_monitor_h.write_to_monitor(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
   endfunction : send_inputs

   function void send_outputs();
   		outputs_monitor_h.write_to_monitor(rrst_n, wrst_n, data_in, w_en, r_en, data_out, empty, full, operation_interface);
   endfunction : send_outputs

   assign FIFO_full = ((wrap_around) & (write_pointer === read_pointer));
   assign FIFO_empty = (!wrap_around) & (write_pointer === read_pointer);
  
  initial begin
    forever begin
      @(incorrect_counter)
      $display("-------------------------------------------------------------------------------------------------------------------------------------------------------------");
      $display("INCORRECT FLAG ASSERTION/DEASSERTION COUNTER = %0d", incorrect_counter);
      $display("-------------------------------------------------------------------------------------------------------------------------------------------------------------");
    end
  end
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