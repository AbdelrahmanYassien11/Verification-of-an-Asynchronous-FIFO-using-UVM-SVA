virtual class rand_once_sequence extends base_sequence;
 	`uvm_object_utils(rand_once_sequence);

 	//sequence_item seq_item;
 	reset_sequence reset_sequence_h;

 	function new(string name = "rand_once_sequence");
 		super.new(name);
 	endfunction

 	virtual task pre_body(); 
 		super.pre_body();
 		reset_sequence_h = reset_sequence::type_id::create("");
 	endtask : pre_body

 	virtual task body();
 		`uvm_do_on(seq_item, sequencer_h);
      	`uvm_info("rand_once_sequence", $sformatf(" read_once only: %s", seq_item.convert2string), UVM_HIGH)
 	endtask : body

 endclass