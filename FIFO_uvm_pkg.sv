package FIFO_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	typedef enum {BEFORE_RESET, READ , WRITE} STATE_e;
	parameter FIFO_WIDTH = 8;
   	parameter FIFO_DEPTH = 512;
  	parameter FIFO_SIZE = 512;


	`include "sequence_item.svh"
	`include "sequencer.svh"

	`include "predictor.svh"
	`include "comparator.svh"

	`include "base_sequence.svh"
	`include "reset_sequence.svh"
	
	`include "driver.svh"
	`include "inputs_monitor.svh"
	`include "outputs_monitor.svh"

	`include "agent.svh"
	`include "scoreboard.svh"
	`include "coverage.svh"

	`include "env.svh"

	`include "base_test.svh"
	`include "reset_test.svh"


endpackage : FIFO_pkg