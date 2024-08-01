class read_once_sequence extends read_sequence;
 	`uvm_object_utils(read_once_sequence);

 	sequence_item seq_item;

 	function new(string name = "read_once_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
		super.pre_body();
		seq_item = sequence_item::type_id::create("seq_item");
 		if(!uvm_config_db#(sequence_item)::get(null, "uvm_test_top.env_h.agent_h.sequencer_h.write_once_sequence_h", "seq_item", super.seq_item_from_write)) begin
 			`uvm_fatal(get_full_name(), "Failed to get sequence_item from write_sequence")
 		end

 	endtask : pre_body

 	task body();
 			$display("start of body task");
 			start_item(seq_item);
 			$display("start item has been invoked");
 			seq_item.rst = 1'b0;
 			seq_item.en = 1'b0;
 			seq_item.addr = super.seq_item_from_write.addr;
 			finish_item(seq_item);
 			`uvm_info("read_once_sequence", $sformatf("1 read only: %s", seq_item.convert2string), UVM_HIGH)
 			$display("finish item has been invoked");
 	endtask : body

 endclass