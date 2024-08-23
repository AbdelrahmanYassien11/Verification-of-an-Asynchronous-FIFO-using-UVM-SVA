
class sequence_item extends uvm_sequence_item;
 	`uvm_object_utils(sequence_item);

 	function new(string name = "sequence_item");
 		super.new(name);
 	endfunction

rand int unsigned randomized_number_of_tests;
rand STATE_e operation;


rand  logic                   wrst_n;
rand  logic                   rrst_n;
rand  bit                     w_en;
rand  bit                     r_en;
rand  bit   [FIFO_WIDTH-1:0]  data_in;

      logic [FIFO_WIDTH-1:0]  data_out;
      logic                   empty;
      logic                   full;

      rand STATE_e state;
      // the values that will be randomized
      //rand bit [FIFO_WIDTH-1:0] data_to_write;
      // active low synchronous reset

       constraint reset_c {rrst_n == wrst_n;
       }

       constraint RESET_c { operation dist {0:=5, 1:=40, 2:=60, 3:=0};
       }


      constraint data_in_c { data_in dist {'h00:/1, 'hFF:/1, ['h01 : 'hFE]:/40};
      }

      constraint operation_c {operation == RESET -> rrst_n == 1'b0 && wrst_n == 1'b0;
                              operation == WRITE -> rrst_n == 1'b1 && wrst_n == 1'b1 && w_en == 1'b1 && r_en == 1'b0;
                              operation == READ ->  rrst_n == 1'b1 && wrst_n == 1'b1 && w_en == 1'b0 && r_en == 1'b1;
                              operation == WRITE_READ -> rrst_n == 1'b1 && wrst_n == 1'b1 && w_en == 1'b1 && r_en == 1'b1;
                              }

      constraint randomized_test_number_c { randomized_number_of_tests inside {[100 :150]};    
      }



    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      sequence_item tested;
      bit               same;
      
      if (rhs==null) `uvm_fatal(get_type_name(), 
                                "Tried to do comparison to a null pointer");
      
      if (!$cast(tested,rhs)) begin
        same = 0;
        $display("couldnt compare");
      end
      else begin
        same = super.do_compare(rhs, comparer) && 
               //(tested.rrst_n == rrst_n) &&
               //(tested.wrst_n == wrst_n) &&
               //(tested.data_in == data_in) &&
               //(tested.w_en == w_en) &&
               //(tested.r_en == r_en) &&

               (tested.data_out === data_out); /*&&
               (tested.empty == empty) &&
               (tested.full == full);)*/
      end
      return same;
    endfunction : do_compare




    function void do_copy(uvm_object rhs);
      sequence_item to_be_copied;

      assert(rhs != null) else
        $fatal(1,"Tried to copy null transaction");

      assert($cast(to_be_copied,rhs)) else
        $fatal(1,"Faied cast in do_copy");

      super.do_copy(rhs);	// give all the variables to the parent class, so it can be used by to_be_copied
      wrst_n = to_be_copied.wrst_n;
      rrst_n = to_be_copied.rrst_n;

      data_in = to_be_copied.data_in;

      w_en = to_be_copied.w_en;
      r_en = to_be_copied.r_en;

      data_out = to_be_copied.data_out;

      empty = to_be_copied.empty;
      full = to_be_copied.full;
    endfunction : do_copy

    function string convert2string();
      string            s;

      s = $sformatf(" time: %t  wrst_n:%0d  rrst_n:%0d  data_in: %0d  w_en: %0d  r_en: %0d  data_out: %0d  empty: %0d  full: %0d   incorrect flag assertion = %0d",
                    $time, wrst_n, rrst_n, data_in, w_en, r_en, data_out, empty, full, incorrect_counter);
      return s;
    endfunction : convert2string

    function string output2string();
      string s;
      s= $sformatf(" time: %t  data_out: %0d  empty: %0d   full: %0d",
                    $time, data_out, empty, full);
      return s;
    endfunction


    function sequence_item clone_me();
    	sequence_item clone;
    	uvm_object tmp;

    	tmp = this.clone;
    	$cast(clone, tmp);
    	return clone;
    endfunction : clone_me



 endclass