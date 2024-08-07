class write_read_rand_sequence extends base_sequence;
 	`uvm_object_utils(write_read_rand_sequence);

 	//sequence_item seq_item;
 	reset_sequence reset_sequence_h;
 	write_once_rand_sequence  write_once_rand_sequence_h;
 	read_once_rand_sequence   read_once_rand_sequence_h;

 	sequence_item seq_item_rand_tests;

 	function new(string name = "write_read_rand_sequence");
 		super.new(name);
 	endfunction

 	task pre_body();
 		$display("start of pre_body task");
 		seq_item = sequence_item::type_id::create("seq_item");
 		seq_item_rand_tests = sequence_item::type_id::create("seq_item_rand_tests");
 	endtask : pre_body

 	task body();
 		reset_sequence_h.start(m_sequencer);
 		seq_item_rand_tests.randomize();
 		repeat(seq_item_rand_tests.randomized_number_of_tests) begin
 		 	assert(seq_item.randomize());
 		 	if(seq_item.operation == WRITE) begin
 		 		write_once_rand_sequence_h.start(m_sequencer);
 		 	end
 		 	else if(seq_item.operation == READ) begin
				read_once_rand_sequence_h.start(m_sequencer);
			end
			else if(seq_item.operation == RESET) begin
 		 		reset_sequence reset_sequence_h;
 		 	end
 		end
 	endtask : body
 endclass