class reset_write_read_sequence extends	base_sequence;
 	`uvm_object_utils(reset_write_read_sequence);

 	protected reset_sequence reset_sequence_h;
 	protected write_once_sequence write_once_sequence_h;
 	protected read_once_sequence read_once_sequence_h;
 	 sequence_item seq_item;

 	function new(string name = "reset_write_read_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");

 		seq_item = sequence_item::type_id::create("seq_item");
 		write_once_sequence_h = write_once_sequence::type_id::create("write_once_sequence_h");
 		reset_sequence_h = reset_sequence::type_id::create("reset_sequence_h");
 		read_once_sequence_h = read_once_sequence::type_id::create("read_once_sequence_h");
 	endtask : pre_body

 	task body();
 			$display("start of body task");
 			reset_sequence_h.start(m_sequencer);
 			write_once_sequence_h.start(m_sequencer);
 			read_once_sequence_h.start(m_sequencer);
 			$display("finish item has been invoked");
 	endtask : body

 endclass