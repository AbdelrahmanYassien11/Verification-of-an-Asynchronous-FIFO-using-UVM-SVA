class write_once_sequence extends write_sequence;
 	`uvm_object_utils(write_once_sequence);

 	//protected reset_sequence reset_sequence_h;

 	function new(string name = "write_once_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		super.pre_body();
 	endtask : pre_body

 	task body();
 		super.body();
 	endtask : body

 	task post_body();
 		super.post_body();
 		uvm_config_db#(sequence_item)::set(null, get_full_name(), "seq_item", super.seq_item);
 		`uvm_info("write_once_sequence", get_full_name(), UVM_LOW);
 	endtask : post_body
 endclass