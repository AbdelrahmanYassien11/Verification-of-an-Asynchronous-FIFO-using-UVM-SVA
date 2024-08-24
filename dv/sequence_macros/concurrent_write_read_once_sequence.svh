class concurrent_write_read_once_sequence extends base_sequence;
 	`uvm_object_utils(concurrent_write_read_once_sequence);

 	static bit reset_flag;

 	sequence_item seq_item_concurrent;

 	reset_sequence reset_sequence_h;

 	function new(string name = "concurrent_write_read_once_sequence");
 		super.new(name);
 	endfunction

 	 task pre_body();
 		$display("start of pre_body task");
 		super.pre_body();

 		//`uvm_create(seq_item)
 	endtask : pre_body

 	task body();

 		if(!reset_flag)
 			`uvm_do_on(reset_sequence_h, sequencer_h)

 		`uvm_create(seq_item_concurrent)
 		seq_item_concurrent.operation_rand_c.constraint_mode(0);
 		assert(seq_item_concurrent.randomize() with {operation == WRITE_READ;});
 		`uvm_send(seq_item_concurrent)

 	endtask : body

 endclass