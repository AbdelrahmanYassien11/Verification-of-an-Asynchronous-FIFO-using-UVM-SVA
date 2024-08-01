
import package_FIFO_tb::*;

module FIFO_tb(FIFO_if.TEST f_if);


  //class handle
	RAM_inputs obj1, obj2;

  //testbench thingies  
  bit            			 	    clk;

	bit         			 	      rst_n;
	bit 	[FIFO_WIDTH-1:0]	  data_in;
	bit 					 	          wr_en;
	bit 		 		 		          rd_en;

	logic	[FIFO_WIDTH-1:0]  	data_out;
	logic           	 		    wr_ack;
	logic						          overflow;
	logic 					          underflow;
	logic						          almost_empty;
	logic						          empty;
	logic						          almost_full;
	logic						          full;
  logic                     half_full;



	assign clk = f_if.clk;

	assign f_if.rst_n 		= rst_n;
	assign f_if.data_in 	= data_in;
	assign f_if.wr_en 		= wr_en;
	assign f_if.rd_en 		= rd_en;

	assign data_out 	    = f_if.data_out;
	assign wr_ack 		    = f_if.wr_ack;
	assign overflow 	    = f_if.overflow;
	assign underflow     	= f_if.underflow;
	assign almost_empty 	= f_if.almost_empty;
	assign empty 		      = f_if.empty;
	assign almost_full 	  = f_if.almost_full;
	assign full 		      = f_if.full;
  assign half_full      = f_if.half_full;



	// Arbitrary signal to indicate when to start/stop sampling of MOSI_COMM bit which cover all possible CMDs. I DID NOT USE IT, WAS JUST CHECKING IF I COULD
 	 bit CovgrpsSample;
   
  //A variable to indicate at which word the test bench is at and to control the expecteed output flags
    bit [31:0] write_pointer;
    bit [31:0] read_pointer;
  
  // A casted enum variable made to display the RANDOMIZED operation being done in the test bench in the waveform 
   STATE_e OPERATION_tb;


//Arrays to be used in the test bench
    bit [FIFO_WIDTH-1:0] Data_Read;
  	bit [FIFO_WIDTH-1:0] data_read_queue[$];
    bit [FIFO_WIDTH-1:0] data_write_queue[$];


  initial begin
    OPERATION_tb = BEFORE_RESET;
	 	obj1 = new();
	 	obj2 = new();
	 	
    	assert_reset;

    	 OPERATION_tb = WRITE;

      for(int i = 0; i < TESTS_WRITE; i++ ) begin
          
       	assert(obj1.randomize());
   		 	FIFO_WRITE;

   		end
  
   		 //$display("FINISHED THE %0d WRITEs", TESTS_READ);

      OPERATION_tb = READ;

   		for(int i = 0; i < TESTS_READ; i++ ) begin

   			assert(obj1.randomize());
   		 	FIFO_READ;

   		end
   		//$display("FINISHED THE %0d READs", TESTS_READ);

   		 // ----------------------------------------------------------------------------------------- Do the test --------------------------------------------------------------------------------
   		    			assert(obj2.randomize());
   		for(int i = 0; i < obj2.TESTS_randomized; i++ ) begin
   			if(i == 0) begin
   				$display("The number of the randomized tests is %0d",obj1.TESTS_randomized);
   			end
   			assert(obj1.randomize());
   		 	read_write_randomize;
   		end
    $display("-------- TEST CASES --------");
    $display("Correct Cases   = %0d",correct_count);
    $display("Incorrect Cases = %0d",error_count);

		
	 $stop;
  end //initial block



  	always @(posedge rst_n) begin
		
		obj1.OPERATION_covgrp.start;
		obj1.FLAGS_covgrp.start;

	end

	always @(posedge clk) begin

		//if (CovgrpsSample) begin	
			obj1.full_expected_cov = full_expected; //edit to the reciever's name in the package
			obj1.almost_full_expected_cov = almost_full_expected; //edit to the reciever's name in the package
			obj1.overflow_expected_cov = overflow_expected; //edit to the reciever's name in the package
			obj1.wr_ack_expected_cov =	wr_ack_expected; //edit to the reciever's name in the package
			obj1.empty_expected_cov = empty_expected; //edit to the reciever's name in the package
			obj1.almost_empty_expected_cov = almost_empty_expected; //edit to the reciever's name in the package
			obj1.underflow_expected_cov = underflow_expected; //edit to the reciever's name in the package
      obj1.half_full_expected_cov = half_full_expected;
			obj1.operation_cov = OPERATION_tb;

		//end

		obj1.OPERATION_covgrp.sample;
		obj1.FLAGS_covgrp.sample;

	end

	always @(negedge rst_n) begin
		
		obj1.OPERATION_covgrp.stop;
		obj1.FLAGS_covgrp.stop;

	end




	//always obj1.rst_n = rst_n;

	task assert_reset;

      @(negedge clk);

      rst_n = 1;
      obj1.rst_n = rst_n;

      $display("reset = %0d", rst_n);

      @(negedge clk);

      rst_n = 0;
      obj1.rst_n = rst_n;

      repeat(10) @(negedge clk);

      CheckOut( 'b0, data_out);


      rst_n = 1;
      obj1.rst_n = rst_n;
      FLAGS_WRITE;
      //FLAGS_READ;


  	endtask : assert_reset


	task CheckOut(input bit [FIFO_WIDTH-1:0] expected, input logic [FIFO_WIDTH-1:0] actual);

      if (expected !== actual) begin
	  		$display("%t: expected data_out 0x%0h but got 0x%0h", $time, expected, actual);
	   		error_count = error_count + 1;
      end
      else begin
      		correct_count = correct_count + 1;
      end

    endtask : CheckOut


//A task that writes address and data
   task FIFO_WRITE();

   	 CovgrpsSample = 1;

   	 @(negedge clk);

   	 //assert(obj1.randomize());
     data_in = obj1.data_to_write; 
     if(full_expected === 0)begin
     	data_write_queue.push_back(obj1.data_to_write); 
     	wr_en = 1;
     end
	   wr_ack_expected = 0; 

     @(negedge clk);

     if(full_expected === 0)begin
        if(write_pointer === 512)begin
          write_pointer = 0;
        end
        else begin
          wr_en = 0;
          write_pointer = write_pointer+1;
        end
     end
     FLAGS_WRITE();
      full_check(full, full_expected);
    	almost_full_check(almost_full, almost_full_expected);
    	overflow_check(overflow, overflow_expected);
    	wr_ack_check(wr_ack, wr_ack_expected);
    	empty_check(empty, empty_expected);
    	almost_empty_check(almost_empty, almost_empty_expected);
    	underflow_check(underflow, underflow_expected);
      half_full_check(half_full, half_full_expected);

     CovgrpsSample = 0;
   
   endtask : FIFO_WRITE



//A task that writes address and data
   task FIFO_READ();

   	 CovgrpsSample = 1;

   	 @(negedge clk);

     if(empty_expected === 0)begin
	 	    Data_Read = data_write_queue.pop_front();
     	  rd_en = 1;
     end

     @(negedge clk);

     if(empty_expected === 0)begin
        if(read_pointer === 512)begin
          rd_en = 0;
          read_pointer = 0;
        end
        else begin
          rd_en = 0;
          read_pointer = read_pointer +1;
        end
     end
     FLAGS_READ();
    	full_check(full, full_expected);
    	almost_full_check(almost_full, almost_full_expected);
    	overflow_check(overflow, overflow_expected);
    	wr_ack_check(wr_ack, wr_ack_expected);
    	empty_check(empty, empty_expected);
    	almost_empty_check(almost_empty, almost_empty_expected);
    	underflow_check(underflow, underflow_expected);
      half_full_check(half_full, half_full_expected);
    	CheckOut(Data_Read,	data_out);

     CovgrpsSample = 0;

   endtask : FIFO_READ

    task FLAGS_WRITE();

    	if ((read_pointer > write_pointer)) begin
        case(read_pointer - write_pointer)
          (1): begin
    		    empty_expected 	= 0;
    		    almost_empty_expected = 0;
    		    underflow_expected = 0;
    		    full_expected 	= 0;
    		    wr_ack_expected = 1;
    		    almost_full_expected = 1;
    		    overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
        endcase
    	end
      else if((write_pointer > read_pointer )) begin
        case(write_pointer - read_pointer)
          (1): begin
            empty_expected  = 0;
            almost_empty_expected = 1;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
        endcase // almost_full_expected
      end
    	else if((write_pointer === read_pointer )) begin
        if(almost_full_expected === 1) begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 1;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else if(full_expected === 1)begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 1;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 1;
            half_full_expected = 0;
        end
        else if(empty_expected === 1)begin
            empty_expected  = 0;
            almost_empty_expected = 1;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else begin
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end 
      end

    endtask : FLAGS_WRITE


      task FLAGS_READ();
      if ((read_pointer > write_pointer)) begin
        case(read_pointer - write_pointer)
          (1): begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 1;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
        endcase
      end
      else if((write_pointer > read_pointer )) begin
        case(write_pointer - read_pointer)
          (1): begin
            empty_expected  = 0;
            almost_empty_expected = 1;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
          (FIFO_SIZE/2): begin //
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 1;
          end
          default: begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 1;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
          end
        endcase // almost_full_expected
      end
      else if((write_pointer === read_pointer )) begin
        if(almost_empty_expected === 1) begin
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else if(empty_expected === 1)begin
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 1;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else if(full_expected === 1)begin
            empty_expected  = 0;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 1;
            overflow_expected = 0;
            half_full_expected = 0;
        end
        else begin
            empty_expected  = 1;
            almost_empty_expected = 0;
            underflow_expected = 0;
            full_expected   = 0;
            wr_ack_expected = 0;
            almost_full_expected = 0;
            overflow_expected = 0;
            half_full_expected = 0;
        end 
      end

   endtask : FLAGS_READ


   	  task full_check(input logic full_actual, input bit full_expected);
   	  	

      		if (full_actual !== full_expected) begin
      			$display ("%t The full flag is %0d, but the expected value is %0d", $time, full_actual, full_expected);
      			error_count = error_count+1;      			
      		end
      		else begin
      			correct_count = correct_count+1;
      		end

   	  endtask : full_check


   	  task almost_full_check(input logic almost_full_actual, input bit almost_full_expected);
   	  	

      		if (almost_full_actual !== almost_full_expected) begin
      			$display ("%t The almost_full flag is %0d, but the expected value is %0d", $time, almost_full_actual, almost_full_expected);
      			error_count = error_count+1;      			
      		end
      		else begin
      			correct_count = correct_count+1;
      		end
      		
   	  endtask : almost_full_check


   	  task overflow_check(input logic overflow_actual, input bit overflow_expected);
   	  	

      		if (overflow_actual !== overflow_expected) begin
      			$display ("%t The overflow flag is %0d, but the expected value is %0d", $time, overflow_actual, overflow_expected);
      			error_count = error_count+1;      			
      		end
      		else begin
      			correct_count = correct_count+1;
      		end
      		
   	  endtask : overflow_check


   	  task wr_ack_check(input logic wr_ack_actual, input bit wr_ack_expected);
   	  	

      		if (wr_ack_actual !== wr_ack_expected) begin
      			$display ("%t The wr_ack flag is %0d, but the expected value is %0d", $time, wr_ack_actual, wr_ack_expected);
      			error_count = error_count+1;      			
      		end
      		else begin
      			correct_count = correct_count+1;
      		end
      		
   	  endtask : wr_ack_check


   	  task empty_check(input logic empty_actual, input bit empty_expected);
   	  	

      		if (empty_actual !== empty_expected) begin
      			$display ("%t The empty flag is %0d, but the expected value is %0d", $time, empty_actual, empty_expected);
      			error_count = error_count+1;      			
      		end
      		else begin
      			correct_count = correct_count+1;
      		end
      		
   	  endtask : empty_check


   	  task almost_empty_check(input logic almost_empty_actual, input bit almost_empty_expected);
   	  	

      		if (almost_empty_actual !== almost_empty_expected) begin
      			$display ("%t The almost_empty flag is %0d, but the expected value is %0d", $time, almost_empty_actual, almost_empty_expected);
      			error_count = error_count+1;      			
      		end
      		else begin
      			correct_count = correct_count+1;
      		end
      		
   	  endtask : almost_empty_check


   	  task underflow_check(input logic underflow_actual, input bit underflow_expected);
   	  	

      		if (underflow_actual !== underflow_expected) begin
      			$display ("%t The underflow flag is %0d, but the expected value is %0d", $time, underflow_actual, underflow_expected);
      			error_count = error_count+1;      			
      		end
      		else begin
      			correct_count = correct_count+1;
      		end
      		
   	  endtask : underflow_check

      task half_full_check(input logic half_full_actual, input bit half_full_expected);
        

          if (half_full_actual !== half_full_expected) begin
            $display ("%t The half_full flag is %0d, but the expected value is %0d", $time, half_full_actual, half_full_expected);
            error_count = error_count+1;            
          end
          else begin
            correct_count = correct_count+1;
          end
          
      endtask : half_full_check

   	  task read_write_randomize();

   	  		//assert(obj1.randomize());

   	  			OPERATION_tb = obj1.state;
   	  			//obj1.operation_cov = OPERATION_tb;
   	  			if (OPERATION_tb) begin
   	  				FIFO_WRITE;
   	  				//$display("WRITE");
   	  			end
   	  			else begin
   	  				FIFO_READ;
   	  				//$display("READ");
   	  			end

   	  endtask

endmodule : FIFO_tb


















































































