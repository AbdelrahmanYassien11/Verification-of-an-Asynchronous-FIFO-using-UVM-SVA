module top_test_uvm();
	import uvm_pkg::*;
	import FIFO_pkg::*;

	
	bit wclk;
	bit rclk;

    always #CYCLE_WRITE wclk = ~wclk;
    always #CYCLE_READ rclk = ~rclk;

	inf f_if(wclk, rclk);

	async_fifo1 DUT(
				.wclk(f_if.wclk),
				.wrst_n(f_if.wrst_n),
				.rclk(f_if.rclk),
				.rrst_n(f_if.rrst_n),
				.w_en(f_if.w_en),
				.r_en(f_if.r_en),
				.data_in(f_if.data_in),
				.data_out(f_if.data_out),
				.full(f_if.full),
				.empty(f_if.empty)
		);

	bind FIFO FIFO_sva sva(f_if);



	initial begin
		uvm_config_db#(virtual inf.TEST)::set(null,"uvm_test_top", "my_vif", f_if);
		run_test();
	end

endmodule
