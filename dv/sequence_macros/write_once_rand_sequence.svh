class write_once_rand_sequence extends rand_once_sequence;
 	`uvm_object_utils(write_once_rand_sequence);

 	static bit reset_flag;
 	reset_sequence reset_sequence_h;

 	function new(string name = "write_once_rand_sequence");
 		super.new(name);
 	endfunction

 	task body();
 		if(!reset_flag) begin 
 			`uvm_do_on(reset_sequence_h, sequencer_h)
 		end
 		`uvm_do_on_with(seq_item, sequencer_h, {operation == WRITE;})
 	endtask : body

 endclass
