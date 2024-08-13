 module ff_tb();

 	bit clk;
 	logic rst_n, d, q;


always #5ns clk = ~clk;

 	inf inf1(clk);



 ff dut0(

	.clk(clk),
	.d(inf1.d), 
	.rst_n(inf1.rst_n), 
	.q(inf1.q)

	);

assign q = inf1.q;
assign inf1.d = d;
assign inf1.rst_n = rst_n;



  clocking cb_r @(posedge clk);
    default input #2ps output negedge;
    input  q;
    output rst_n, d;
  endclocking
  default clocking cb_r;


  initial begin 
  	// @(negedge clk);
  	##1;
  	$display("time :%t rst_n = %0d cb_r.rst_n = %0d",$time, rst_n, cb_r.rst_n);
  	cb_r.rst_n <= 0;
  	//@(negedge clk);
  	##1;
  	$display("time: %t rst_n = %0d cb_r.rst_n = %0d",$time, rst_n, cb_r.rst_n);
  	$display("time: %t q = %0d cb_r.q = %0d",$time, q, cb_r.q);


  end


endmodule : ff_tb