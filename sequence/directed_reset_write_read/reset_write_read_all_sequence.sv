class reset_write_read_all_sequence extends	uvm_sequence #(sequence_item);
 	`uvm_object_utils(reset_write_read_all_sequence);

 	protected reset_sequence reset_sequence_h;
 	protected write_sequence write_all_sequence_h;
 	protected read_sequence read_all_sequence_h;
 	 sequence_item seq_item;

 	function new(string name = "reset_write_read_all_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");

 		seq_item = sequence_item::type_id::create("seq_item");
 		write_all_sequence_h = write_sequence::type_id::create("write_all_sequence_h");
 		reset_sequence_h = reset_sequence::type_id::create("reset_sequence_h");
 		read_all_sequence_h = read_sequence::type_id::create("read_all_sequence_h");
 	endtask : pre_body

 	task body();
 			$display("start of body task");
 			reset_sequence_h.start(m_sequencer);
 			write_all_sequence_h.start(m_sequencer);
 			read_all_sequence_h.start(m_sequencer);
 			$display("finish item has been invoked");
 	endtask : body

 endclass