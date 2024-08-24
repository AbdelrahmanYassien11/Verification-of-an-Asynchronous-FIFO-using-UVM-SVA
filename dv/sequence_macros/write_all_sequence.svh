class write_all_sequence extends write_once_sequence;
 	`uvm_object_utils(write_all_sequence);

 	//sequence_item seq_item;
 	static bit reset_flag;

	write_once_sequence write_once_sequence_h;
 	function new(string name = "write_all_sequence");
 		super.new(name);
 	endfunction

 	 task pre_body();
 		$display("start of pre_body task");
 		super.pre_body();
 		write_once_sequence_h = write_once_sequence::type_id::create("write_once_sequence_h");
 	endtask : pre_body

 	task body();
 		if(!reset_flag)
 			`uvm_do_on(reset_sequence_h, sequencer_h)

 		write_once_sequence::reset_flag = 1'b1;

 		repeat(FIFO_DEPTH+1) begin
 			`uvm_do_on(write_once_sequence_h, sequencer_h)
 		end
 	endtask : body

 endclass