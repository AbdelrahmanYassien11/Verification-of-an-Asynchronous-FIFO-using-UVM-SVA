class write_all_sequence extends write_once_sequence;
 	`uvm_object_utils(write_all_sequence);

 	//sequence_item seq_item;

 	function new(string name = "write_all_sequence");
 		super.new(name);
 	endfunction

 	task body();
 		reset_sequence_h.start(m_sequencer);
 		repeat(FIFO_DEPTH) begin
			start_item(seq_item);
 			$display("start item has been invoked");
 			assert(seq_item.randomize());
 			seq_item.rst_n = 1'b1;
 			seq_item.wr_en = 1'b1;
 			seq_item.rd_en = 1'b0;
 			finish_item(seq_item);
      		`uvm_info("write_once_SEQUENCE", $sformatf(" write_once only: %s", 
      		seq_item.convert2string), UVM_HIGH)
 			$display("finish item has been invoked");
 		end
 	endtask : body

 endclass