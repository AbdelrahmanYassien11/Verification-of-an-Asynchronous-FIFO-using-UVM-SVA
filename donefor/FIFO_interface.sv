import package_FIFO_tb::*;
interface FIFO_if(clk);

	input bit clk;


	logic         			 	rst_n;
	bit 	[FIFO_WIDTH-1:0]	data_in;
	bit 					 	wr_en;
	bit 		 		 		rd_en;

	logic	[FIFO_WIDTH-1:0]  	data_out;
	logic           	 		wr_ack;
	logic						overflow;
	logic 						underflow;
	logic						almost_empty;
	logic						empty;
	logic						almost_full;
	logic						full;
	logic						half_full;

	


	modport DUT (input clk, rst_n, data_in, wr_en, rd_en, output wr_ack, overflow, underflow, almost_empty, empty, almost_full, full, half_full, data_out );
	modport TEST (input wr_ack, overflow, underflow, almost_empty, empty, almost_full, full, half_full, data_out, output clk, rst_n, data_in, wr_en, rd_en);
	modport MONITOR (input wr_ack, overflow, underflow, almost_empty, empty, almost_full, full, half_full, data_out, clk, rst_n, data_in, wr_en, rd_en);
	modport SVA (input wr_ack, overflow, underflow, almost_empty, empty, almost_full, full, half_full, data_out ,  clk, rst_n, data_in, wr_en, rd_en);
	
endinterface