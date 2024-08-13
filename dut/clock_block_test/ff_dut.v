module ff(
			input d, rst_n, clk,

			output q);

reg q_reg;

always @(posedge clk or negedge rst_n) begin
	if (! rst_n) begin
		q_reg <= 0;
	end
	else begin
		q_reg <= d;		
	end
end

assign q = q_reg;


endmodule