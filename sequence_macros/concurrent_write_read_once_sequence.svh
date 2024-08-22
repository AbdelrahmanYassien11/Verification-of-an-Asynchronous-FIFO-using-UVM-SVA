class concurrent_write_read_once_sequence extends base_sequence;
 	`uvm_object_utils(concurrent_write_read_once_sequence);

 	static bit reset_flag;

 	reset_sequence reset_sequence_h;

 	function new(string name = "concurrent_write_read_once_sequence");
 		super.new(name);
 	endfunction

 	 task pre_body();
 		$display("start of pre_body task");
 		super.pre_body();
 	endtask : pre_body

 	task body();

 		if(!reset_flag)
 			`uvm_do_on(reset_sequence_h, sequencer_h)

 		
 			`uvm_do_on_with(seq_item, sequencer_h, {operation == WRITE_READ;})

 	endtask : body

 endclass