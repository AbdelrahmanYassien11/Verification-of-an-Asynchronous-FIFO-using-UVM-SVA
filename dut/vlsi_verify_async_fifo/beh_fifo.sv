 module beh_fifo (rdata, wfull, rempty, wdata, winc, wclk, wrst_n, rinc, rclk, rrst_n);
 parameter DSIZE = 8;
 parameter ASIZE = 4;
 output [DSIZE-1:0] rdata;
 output wfull;
 output rempty;
 input [DSIZE-1:0] wdata;
 input winc, wclk, wrst_n;
 input rinc, rclk, rrst_n;


 reg [ASIZE:0] wptr, wrptr1, wrptr2, wrptr3;
 reg [ASIZE:0] rptr, rwptr1, rwptr2, rwptr3;


 parameter MEMDEPTH = 1<<ASIZE;

 reg [DSIZE-1:0] ex_mem [0:MEMDEPTH-1];
 always @(posedge wclk or negedge wrst_n)
 	if (!wrst_n) wptr <= 0;
 	else if (winc && !wfull) begin
 		ex_mem[wptr[ASIZE-1:0]] <= wdata;
 		wptr <= wptr+1;
 	end


 always @(posedge wclk or negedge wrst_n)
 	if (!wrst_n) {wrptr3,wrptr2,wrptr1} <= 0;
 	else {wrptr3,wrptr2,wrptr1} <= {wrptr2,wrptr1,rptr};

 always @(posedge rclk or negedge rrst_n)
 	if (!rrst_n) rptr <= 0;
 	else if (rinc && !rempty) rptr <= rptr+1;

 always @(posedge rclk or negedge rrst_n)
 	if (!rrst_n) {rwptr3,rwptr2,rwptr1} <= 0;
 	else {rwptr3,rwptr2,rwptr1} <= {rwptr2,rwptr1,wptr};

 assign rdata = ex_mem[rptr[ASIZE-1:0]];
 assign rempty = (rptr == rwptr3);
 assign wfull = ((wptr[ASIZE-1:0] == wrptr3[ASIZE-1:0]) && (wptr[ASIZE] != wrptr3[ASIZE] ));
 
endmodule