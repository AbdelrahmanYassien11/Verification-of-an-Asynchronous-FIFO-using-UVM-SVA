class read_sequence extends base_sequence;
 	`uvm_object_utils(read_sequence);

 	sequence_item seq_item, seq_item_from_write;

 	function new(string name = "read_sequence");
 		super.new(name);
 	endfunction

 	virtual task pre_body();
 		$display("start of pre_body task");
		seq_item = sequence_item::type_id::create("seq_item");
		seq_item_from_write = sequence_item::type_id::create("seq_item_from_write");
 	endtask : pre_body

 	virtual task body();
 				$display("start of body task");
 				repeat(16) begin
 					start_item(seq_item);
 					$display("start item has been invoked");
 					seq_item.rst = 1'b0;
 					seq_item.en = 1'b0;
 					assert(seq_item.randomize());
 					finish_item(seq_item);
 					`uvm_info("read_once_sequence", $sformatf("1 read only: %s", seq_item.convert2string), UVM_HIGH)
 				end
 				$display("finish item has been invoked");
 	endtask : body

 endclass