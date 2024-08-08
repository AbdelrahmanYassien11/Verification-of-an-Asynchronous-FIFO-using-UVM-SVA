class write_once_rand_sequence extends rand_once_sequence;
 	`uvm_object_utils(write_once_rand_sequence);

 	static bit reset_flag;
 	reset_sequence reset_sequence_h;

 	function new(string name = "write_once_rand_sequence");
 		super.new(name);
 	endfunction

 	task body();
 		if(!reset_flag) begin 
 			reset_sequence_h = reset_sequence::type_id::create("reset_sequence_h");
 			reset_sequence_h.start(m_sequencer);
 		end
 		seq_item.rd_en.rand_mode(0);
 		super.body();
 	endtask : body

 endclass
