class rand_once_sequence extends base_sequence;
 	`uvm_object_utils(rand_once_sequence);

 	//sequence_item seq_item;

 	function new(string name = "rand_once_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");
 		seq_item = sequence_item::type_id::create("seq_item");
 	endtask : pre_body

 	task body();
 			$display("start of body task");
 			start_item(seq_item);
 			$display("start item has been invoked");
 			assert(seq_item.randomize());
 			finish_item(seq_item);
      `uvm_info("rand_once_sequence", $sformatf(" read_once only: %s", seq_item.convert2string), UVM_HIGH)
 			$display("finish item has been invoked");
 	endtask : body

 endclass