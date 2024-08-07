class read_once_rand_sequence extends rand_once_sequence;
 	`uvm_object_utils(read_once_rand_sequence);

 	//sequence_item seq_item;

 	function new(string name = "read_once_rand_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");
 		seq_item = sequence_item::type_id::create("seq_item");
 	endtask : pre_body

 	task body();
 		seq_item.wr_en.rand_mode(0);
 		super.body();
 	endtask : body

 endclass