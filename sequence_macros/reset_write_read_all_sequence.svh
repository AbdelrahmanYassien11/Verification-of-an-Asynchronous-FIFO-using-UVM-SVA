class reset_write_read_all_sequence extends	base_sequence;
 	`uvm_object_utils(reset_write_read_all_sequence);

 	protected write_all_sequence write_all_sequence_h;
 	protected read_all_sequence read_all_sequence_h;

 	function new(string name = "reset_write_read_all_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		super.pre_body();
 		write_all_sequence_h = write_all_sequence::type_id::create("write_all_sequence_h");
 		read_all_sequence_h = read_all_sequence::type_id::create("read_all_sequence_h");
 	endtask : pre_body

 	task body();
 			`uvm_do_on(write_all_sequence_h, sequencer_h)
 			`uvm_do_on(read_all_sequence_h, sequencer_h)
 	endtask : body

 endclass