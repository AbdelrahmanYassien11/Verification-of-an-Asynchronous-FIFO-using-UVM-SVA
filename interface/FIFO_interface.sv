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


	task generic_reciever(input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDTH-1:0] idata_in, input bit iw_en, input bit ir_en, input STATE_e ioperation);
    operation_interface = ioperation; 
    send_inputs(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
    wrst_n = iwrst_n;
    rrst_n = irrst_n;
		if((wrst_n === 1'b0) || (rrst_n === 1'b0)) begin
			reset_FIFO(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
    end
		else begin
      write_read_FIFO(irrst_n, iwrst_n, idata_in, iw_en, ir_en); 
    end
	endtask : generic_reciever



  task wait_rdcycles();
    @(posedge rclk);
    repeat(3)
      @(negedge wclk);
  endtask : wait_rdcycles

  task wait_wrcycles();
    @(posedge wclk);
    repeat(3)
      @(negedge rclk);
  endtask : wait_wrcycles

	

  task reset_FIFO(input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDTH-1:0] idata_in, input bit iw_en, input bit ir_en);
      fork
        read_reset();
        write_reset();
      join
      wrst_n = 1;
      rrst_n = 1;
      fork
        wait_wrcycles();
        wait_rdcycles();
      join
      send_outputs(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
 	endtask : reset_FIFO

  task read_reset();
    read_pointer = 0;
    rrst_n = 0;
    wrap_around = 0;
    @(negedge rclk);
  endtask : read_reset

  task write_reset();
    write_pointer = 0;
    wrst_n = 0;
    wrap_around = 0;
    @(negedge wclk);
  endtask : write_reset


  task write_read_FIFO(input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDTH-1:0] idata_in, input bit iw_en, input bit ir_en);
    if((iw_en === 1'b1) && (ir_en === 1'b1))begin
      fork
        read_FIFO();
        write_FIFO(idata_in);
      join
    end
    else if ((iw_en === 1'b1) && (ir_en === 1'b0)) begin
      write_FIFO(idata_in);
    end
    else if ((iw_en === 1'b0) && (ir_en === 1'b1)) begin
      read_FIFO();
    end
    send_outputs(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
  endtask : write_read_FIFO


 	task write_FIFO(input bit [FIFO_WIDTH-1:0] idata_in);
 		@(negedge wclk);
      wrst_n = 1'b1;
 			w_en = 1'b1;
 			data_in = idata_in;
    fork
      begin
        @(negedge wclk);
        w_en = 0;
        if(!FIFO_full) begin
          if(write_pointer === FIFO_SIZE-1) begin
            write_pointer = 0;
            wrap_around = 1;
          end
          else begin
            write_pointer = write_pointer +1;
          end
        end
      end
      begin
        wait_rdcycles();
      end 
    join

	endtask : write_FIFO


 	task read_FIFO();
 		@(negedge rclk);
      rrst_n = 1'b1;
  		r_en = 1'b1;
    fork
      begin
        @(negedge rclk);
        r_en = 0;
        if(!FIFO_empty)begin
          if(read_pointer === FIFO_SIZE-1) begin
            read_pointer = 0;
            wrap_around = 0;
          end
          else begin
            read_pointer = read_pointer +1;
          end
        end
      end
      begin
        wait_wrcycles();
      end
    join
 	endtask : read_FIFO


  property full_p;
    @(negedge wclk)
    disable iff(!rrst_n && !wrst_n)
      $rose(FIFO_full) |-> ##[0:$] (!FIFO_full ##[1:3] $fell(full));
  endproperty


  assert property (full_p) correct_counter = correct_counter+1;
   else begin
      incorrect_counter = incorrect_counter +1;
      $display("time: %0t  full flag asserted and deasserted INCORRECTLY", $time());
    end
  cover property (full_p);


  property empty_p;
    @(negedge rclk)
    disable iff(!rrst_n && !wrst_n)
      $rose(FIFO_empty) |-> ##[0:$] (!FIFO_empty ##[2:3] $fell(empty)); /*( (empty)  until (!FIFO_empty ##1 $fell(empty)) ##[1:2] $fell(empty));*/ /*(empty throughout FIFO_empty) ##[2:3] $fell(empty)*/
  endproperty

  assert property (empty_p) correct_counter = correct_counter+1; 
    else begin
      incorrect_counter = incorrect_counter +1;
      $display("time: %0t empty flag asserted and deasserted INCORRECTLY", $time());
    end
  cover property (empty_p);


   function void send_inputs(input bit irrst_n, input bit iwrst_n, input bit [31:0] idata_in, input bit iw_en, input bit ir_en);
      inputs_monitor_h.write_to_monitor(irrst_n, iwrst_n, idata_in, iw_en, ir_en);
   endfunction : send_inputs

   function void send_outputs(input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDTH-1:0] idata_in, input bit iw_en, input bit ir_en);
   		outputs_monitor_h.write_to_monitor(irrst_n, iwrst_n, idata_in, iw_en, ir_en, data_out, empty, full, operation_interface);
   endfunction : send_outputs

   //  function void send_concurrent_outputs(input bit ir_en, iw_en);
   //    outputs_monitor_h.write_to_monitor(rrst_n, wrst_n, data_in, iw_en, ir_en, data_out, empty, full, operation_interface);
   // endfunction : send_concurrent_outputs

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

