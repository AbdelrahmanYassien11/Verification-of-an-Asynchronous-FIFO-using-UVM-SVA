class write_once_sequence extends base_sequence;
 	`uvm_object_utils(write_once_sequence);


 	static bit reset_flag;
 	reset_sequence reset_sequence_h;


 	function new(string name = "write_once_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");
 		super.pre_body();
 		reset_sequence_h = reset_sequence::type_id::create("reset_sequence_h");
 	endtask : pre_body

 	virtual task body();

 		if(!reset_flag)
 			reset_sequence_h.start(m_sequencer);
 		seq_item.operation.rand_mode(0);
 		start_item(seq_item);
 		seq_item.operation = WRITE;
 		assert(seq_item.randomize());
 		seq_item.rrst_n = 1'b1;
 		seq_item.wrst_n = 1'b1;
 		seq_item.w_en = 1'b1;
 		seq_item.r_en = 1'b0;
 		finish_item(seq_item);
       	`uvm_info("write_once_SEQUENCE", $sformatf(" write_once only: %s", seq_item.convert2string), UVM_HIGH)
 	endtask : body

 endclass