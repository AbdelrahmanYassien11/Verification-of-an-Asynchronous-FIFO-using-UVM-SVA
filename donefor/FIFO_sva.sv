module FIFO_sva (FIFO_if.SVA f_if);

	parameter FIFO_WIDTH = 16;

	bit         			 	rst_n_sva;
	bit 	[FIFO_WIDTH-1:0]	data_in_sva;
	bit 					 	wr_en_sva;
	bit 		 		 		rd_en_sva;
	bit							clk_sva;

	logic	[FIFO_WIDTH-1:0]  	data_out_sva;
	logic           	 		wr_ack_sva;
	logic						overflow_sva;
	logic 						underflow_sva;
	logic						almost_empty_sva;
	logic						empty_sva;
	logic						almost_full_sva;
	logic						full_sva;

	assign clk_sva = f_if.clk;

	assign rst_n_sva 		= f_if.rst_n;
	assign data_in_sva		= f_if.data_in;
	assign wr_en_sva 		= f_if.wr_en;
	assign rd_en_sva 		= f_if.rd_en;

	assign data_out_sva 	= f_if.data_out;
	assign wr_ack_sva		= f_if.wr_ack;
	assign overflow_sva 	= f_if.overflow;
	assign underflow_sva 	= f_if.underflow;
	assign almost_empty_sva 	= f_if.almost_empty;
	assign empty_sva		= f_if.empty;
	assign almost_full_sva 	= f_if.almost_full;
	assign full_sva			= f_if.full;

	property overflow_high;

		@(posedge clk_sva)	full_sva && wr_en_sva |=> overflow_sva;

	endproperty

	property underflow_high;

		@(posedge clk_sva) empty_sva && rd_en_sva |=> underflow_sva;

	endproperty

	property wr_ack_sva_high;

		@(posedge clk_sva) (!full_sva && wr_en_sva |=> wr_ack_sva);

	endproperty

	property wr_ack_sva_low;

		@(posedge clk_sva) (full_sva |=> !wr_ack_sva);

	endproperty

	property full_high;

		@(posedge clk_sva) (almost_full_sva && wr_en_sva |=> full_sva);

	endproperty

	property empty_high;

		@(posedge clk_sva) (almost_empty_sva && rd_en_sva |=> empty_sva);

	endproperty


	overflow_high_assert: 	assert property (overflow_high);
	underflow_high_assert: 	assert property (underflow_high);
	wr_ack_sva_high_assert: assert property (wr_ack_sva_high);
	wr_ack_sva_low_assert: 	assert property (wr_ack_sva_low);
	full_high_assert: 		assert property (full_high);
	empty_high_assert: 		assert property (empty_high);

	// Assertions coverage

	overflow_high_cover:   cover property (overflow_high);
	underflow_high_cover:  cover property (underflow_high);
	wr_ack_sva_high_cover: cover property (wr_ack_sva_high);
	wr_ack_sva_low_cover:  cover property (wr_ack_sva_low);
	full_high_cover: 	   cover property (full_high);
	empty_high_cover: 	   cover property (empty_high);


endmodule : FIFO_sva











