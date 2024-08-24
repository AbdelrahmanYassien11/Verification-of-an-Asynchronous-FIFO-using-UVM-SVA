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
 		//reset_sequence_h = reset_sequence::type_id::create("reset_sequence_h");
 	endtask : pre_body

 	virtual task body();

 		if(!reset_flag)
 			`uvm_do_on(reset_sequence_h, sequencer_h);
 		`uvm_do_on_with(seq_item, sequencer_h, {operation == WRITE;})
       	`uvm_info("write_once_SEQUENCE", $sformatf(" write_once only: %s", seq_item.convert2string), UVM_HIGH)
 	endtask : body

 endclass