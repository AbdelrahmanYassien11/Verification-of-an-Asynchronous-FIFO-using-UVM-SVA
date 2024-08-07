module top();

	bit clk;

    always #5 clk = ~clk;

	inf f_if(clk);
	FIFO DUT(f_if);
	bind FIFO FIFO_sva sva(f_if);

	top_test_uvm top1(f_if);

endmodule