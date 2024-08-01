module FIFO_top();


	bit clk;
	always #1 clk = ~clk;

	FIFO_if f_if(clk);
	FIFO_DUT DUT(f_if);
	FIFO_tb TEST(f_if);

	bind FIFO_DUT FIFO_sva sva(f_if);	
	//monitor MONITOR(arbif);
endmodule