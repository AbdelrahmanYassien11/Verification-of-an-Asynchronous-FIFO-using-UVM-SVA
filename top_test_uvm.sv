module top_test_uvm(inf.TEST f_if);
	import uvm_pkg::*;
	import FIFO_pkg::*;

	

	initial begin
		virtual inf x;
		x = f_if;
		uvm_config_db#(virtual inf.TEST)::set(null,"uvm_test_top", "my_vif", x);
		//$monitor("my_vif.clk: %0d",a.clk);
		uvm_config_db#(virtual interface inf)::set(null,"uvm_test_top.env_h.agent_h.*", "my_vif1", f_if);
		run_test();
		$display("clk: %0d",f_if.clk);
	end

endmodule

