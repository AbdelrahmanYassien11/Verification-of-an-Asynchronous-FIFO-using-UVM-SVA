class read_all_sequence extends read_once_sequence;
 	`uvm_object_utils(read_all_sequence);

 	//sequence_item seq_item;

 	read_once_sequence read_once_sequence_h;
 	function new(string name = "read_all_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");
 		super.pre_body();
 		read_once_sequence_h = read_once_sequence::type_id::create("read_once_sequence_h");
 	endtask : pre_body


 	task body();

 		read_once_sequence::reset_flag = 1'b1;

 		repeat(FIFO_DEPTH+1) begin
 			read_once_sequence_h.start(m_sequencer);
 		end
 	endtask : body

 endclass

