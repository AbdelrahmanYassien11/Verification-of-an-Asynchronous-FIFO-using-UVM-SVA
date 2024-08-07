class read_once_sequence extends base_sequence;
 	`uvm_object_utils(read_once_sequence);

 	//sequence_item seq_item;

 	reset_sequence reset_sequence_h;

 	function new(string name = "read_once_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");
 		seq_item = sequence_item::type_id::create("seq_item");
 		reset_sequence_h = reset_sequence::type_id::create("reset_sequence_h");
 	endtask : pre_body

 	task body();
 			$display("start of body task");
 			reset_sequence_h.start(m_sequencer);
 			start_item(seq_item);
 			$display("start item has been invoked");
 			assert(seq_item.randomize());
 			seq_item.rst_n = 1'b1;
 			seq_item.wr_en = 1'b0;
 			seq_item.rd_en = 1'b1;
 			finish_item(seq_item);
      `uvm_info("read_once_SEQUENCE", $sformatf(" read_once only: %s", seq_item.convert2string), UVM_HIGH)
 			$display("finish item has been invoked");
 	endtask : body

 endclass