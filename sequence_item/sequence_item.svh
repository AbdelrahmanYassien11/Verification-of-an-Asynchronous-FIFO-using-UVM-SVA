
class sequence_item extends uvm_sequence_item;
 	`uvm_object_utils(sequence_item);

 	function new(string name = "sequence_item");
 		super.new(name);
 	endfunction


rand STATE_e operation;


rand  logic                   rst_n;
rand  bit   [FIFO_WIDTH-1:0]  data_in;
rand  bit                     wr_en;
rand  bit                     rd_en;

      logic [FIFO_WIDTH-1:0]  data_out;
      logic                   wr_ack;
      logic                   overflow;
      logic                   underflow;
      logic                   almost_empty;
      logic                   empty;
      logic                   almost_full;
      logic                   full;
      logic                   half_full;

      rand STATE_e state;
      // the values that will be randomized
      //rand bit [FIFO_WIDTH-1:0] data_to_write;
      // active low synchronous reset

      constraint rst_c { rst_n dist {0:=5, 1:=95};
      }

      constraint en_c { wr_en == !rd_en; rd_en == !wr_en;
      }

      constraint data_in_c { data_in dist {16'h0000:=1, [16'h0001 : 16'hFFFE]:=1, 16'hFFFF:=1};
      }

      constraint operation_c {operation == RESET -> rst_n == 1'b0;
                              operation == WRITE -> rst_n == 1'b1 && wr_en == 1'b1 && rd_en == 1'b0;
                              operation == READ -> rst_n == 1'b1 && wr_en == 1'b0 && rd_en == 1'b1;
                              }



    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      sequence_item tested;
      bit               same;
      
      if (rhs==null) `uvm_fatal(get_type_name(), 
                                "Tried to do comparison to a null pointer");
      
      if (!$cast(tested,rhs))
        same = 0;
      else
        same = super.do_compare(rhs, comparer) && 
               (tested.rst_n == rst_n) &&
               (tested.data_in == data_in) &&
               (tested.wr_en == wr_en) &&
               (tested.rd_en == rd_en) &&
               (tested.data_out == data_out) &&
               (tested.wr_ack == wr_ack) &&
               (tested.overflow == overflow) &&
               (tested.underflow == underflow) &&
               (tested.almost_empty == almost_empty) &&
               (tested.empty == empty) &&
               (tested.almost_full == almost_full) &&
               (tested.full == full);
               //(tested.half_full == half_full);
      return same;
    endfunction : do_compare




    function void do_copy(uvm_object rhs);
      sequence_item to_be_copied;

      assert(rhs != null) else
        $fatal(1,"Tried to copy null transaction");

      assert($cast(to_be_copied,rhs)) else
        $fatal(1,"Faied cast in do_copy");

      super.do_copy(rhs);	// give all the variables to the parent class, so it can be used by to_be_copied
      rst_n = to_be_copied.rst_n;
      data_in = to_be_copied.data_in;
      wr_en = to_be_copied.wr_en;
      rd_en = to_be_copied.rd_en;
      data_out = to_be_copied.data_out;
      wr_ack = to_be_copied.wr_ack;
      overflow = to_be_copied.overflow;
      underflow = to_be_copied.underflow;
      almost_empty = to_be_copied.almost_empty;
      empty = to_be_copied.empty;
      almost_full = to_be_copied.almost_full;
      full = to_be_copied.full;
      half_full = to_be_copied.half_full;
    endfunction : do_copy

    function string convert2string();
      string            s;

      s = $sformatf(" time: %t  rst_n:%0d  data_in: %0d  wr_en: %0d  rd_en: %0d  data_out: %0d  wr_ack: %0d  overflow:%0d  underflow: %0d  almost_empty: %0d  empty: %0d   almost_full: %0d   full: %0d  half_full: %0d",
                    $time, rst_n, data_in, wr_en, rd_en, data_out, wr_ack, overflow, underflow, almost_empty, empty, almost_full, full, half_full);
      return s;
    endfunction : convert2string

    function string output2string();
      string s;
      s= $sformatf(" time: %t  data_out: %0d  wr_ack: %0d  overflow:%0d  underflow: %0d  almost_empty: %0d  empty: %0d   almost_full: %0d   full: %0d  half_full: %0d",
                    $time, data_out, wr_ack, overflow, underflow, almost_empty, empty, almost_full, full, half_full);
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