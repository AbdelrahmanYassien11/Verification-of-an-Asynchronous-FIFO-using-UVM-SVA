module top_test_uvm();
	import uvm_pkg::*;
	import FIFO_pkg::*;

	
	bit wclk;
	bit rclk;

    always #CYCLE_WRITE wclk = ~wclk;
    always #CYCLE_READ rclk = ~rclk;

	inf f_if(wclk, rclk);

	fifo1	 DUT(
				.wclk(f_if.wclk),
				.wrst_n(f_if.wrst_n),
				.rclk(f_if.rclk),
				.rrst_n(f_if.rrst_n),
				.winc(f_if.w_en),
				.rinc(f_if.r_en),
				.wdata(f_if.data_in),
				.rdata(f_if.data_out),
				.wfull(f_if.full),
				.rempty(f_if.empty)
		);

	//bind FIFO FIFO_sva sva(f_if);



	initial begin
		uvm_config_db#(virtual inf)::set(null,"uvm_test_top", "my_vif", f_if);
		run_test();
	end

endmodule
