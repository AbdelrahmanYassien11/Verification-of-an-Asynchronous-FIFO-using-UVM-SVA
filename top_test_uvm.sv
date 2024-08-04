module top_test_uvm();
	import uvm_pkg::*;
	import FIFO_pkg::*;



	bit clk;

    always #5 clk = ~clk;

	inf inf1(clk);

	inf f_if(clk);
	FIFO DUT(f_if);
	bind FIFO FIFO_sva sva(f_if);




	initial begin

		uvm_config_db#(virtual inf.TEST)::set(null,"uvm_test_top", "my_vif", f_if.TEST);
		uvm_config_db#(virtual interface inf)::set(null,"uvm_test_top.env_h.agent_h.*", "my_vif1", inf1);
		run_test();
	end

endmodule

