//`include "memory_interface.sv"
module top_test_uvm();
	import uvm_pkg::*;
	import FIFO_pkg::*;


	bit clk;

    always #5 clk = ~clk;

	
	inf f_if(clk);
	FIFO DUT(f_if);

	bind FIFO FIFO_sva sva(f_if);



	initial begin
		//virtual inf vif; vif = inf1; the next line does this
		uvm_config_db#(virtual interface inf)::set(null,"uvm_test_top", "my_vif", f_if);
		run_test();
	end

endmodule

