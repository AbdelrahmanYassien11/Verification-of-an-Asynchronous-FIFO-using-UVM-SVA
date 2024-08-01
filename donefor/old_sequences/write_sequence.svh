class write_sequence extends base_sequence;
 	`uvm_object_utils(write_sequence);

 	//protected reset_sequence reset_sequence_h;
 	sequence_item seq_item;

 	function new(string name = "write_sequence");
 		super.new(name);
 	endfunction

 	virtual task pre_body();
 		$display("start of pre_body task");
 		seq_item = sequence_item::type_id::create("seq_item");
 	endtask : pre_body

 	virtual task body();
 			$display("start of body task");
 			repeat(16) begin
 				start_item(seq_item);
 				$display("start item has been invoked");
 				seq_item.rst = 1'b0;
 				seq_item.en = 1'b1;
 				assert(seq_item.randomize());
 				finish_item(seq_item);
 				`uvm_info("write_sequence", $sformatf("1 write only: %s", seq_item.convert2string), UVM_HIGH)
 			end

 				$display("finish item has been invoked");
 	endtask : body

 	task post_body();
 		$display("start of post_do task");
 	endtask : post_body

 endclass