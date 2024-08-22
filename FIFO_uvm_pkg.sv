package FIFO_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	parameter CYCLE_WRITE = 5;
	parameter CYCLE_READ  = 10;

	typedef enum {RESET, READ , WRITE, WRITE_READ} STATE_e;
	parameter FIFO_WIDTH = 8;
   	parameter FIFO_DEPTH = 8;
  	parameter FIFO_SIZE = 8;
  	int incorrect_counter;
   	int correct_counter;


	`include "sequence_item.svh"
	`include "sequencer.svh"

	`include "passive_agent_config.svh"
	`include "active_agent_config.svh"
	`include "env_config.svh"

	`include "predictor.svh"
	`include "comparator.svh"

	`include "base_sequence.svh"
	`include "reset_sequence.svh"

	`include "write_once_sequence.svh"
	`include "read_once_sequence.svh"
	
	`include "write_all_sequence.svh"
	`include "read_all_sequence.svh"
	`include "reset_write_read_all_sequence.svh"

	`include "rand_once_sequence.svh"
	`include "write_once_rand_sequence.svh"
	`include "read_once_rand_sequence.svh"
	`include "write_read_rand_sequence.svh"

	`include "concurrent_write_read_once_sequence.svh"
	`include "concurrent_write_read_rand_sequence.svh"

	`include "driver.svh"
	`include "inputs_monitor.svh"
	`include "outputs_monitor.svh"

	`include "active_agent.svh"
	`include "passive_agent.svh"
	`include "scoreboard.svh"
	`include "coverage.svh"

	`include "env.svh"

	`include "base_test.svh"
	`include "reset_test.svh"
	`include "write_once_test.svh"
	`include "read_once_test.svh"

	`include "write_all_test.svh"
	//`include "read_all_test.svh" //obselete
	`include "reset_write_read_all_test.svh"

	`include "write_once_rand_test.svh"
	`include "read_once_rand_test.svh"
	`include "write_read_rand_test.svh"

	`include "concurrent_write_read_once_test.svh"
	`include "concurrent_write_read_rand_test.svh"

endpackage : FIFO_pkg