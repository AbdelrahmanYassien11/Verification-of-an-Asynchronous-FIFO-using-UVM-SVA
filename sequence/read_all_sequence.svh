class read_all_sequence extends read_once_sequence;
 	`uvm_object_utils(read_all_sequence);

 	//sequence_item seq_item;


 	function new(string name = "read_all_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");
 		seq_item = sequence_item::type_id::create("seq_item");
 	endtask : pre_body

 	task body();
 		repeat(FIFO_DEPTH)begin
			super.body();
 		end
 	endtask : body

 endclass