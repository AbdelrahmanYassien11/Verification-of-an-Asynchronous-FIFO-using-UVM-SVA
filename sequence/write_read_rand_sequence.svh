class write_read_rand_sequence extends base_sequence;
 	`uvm_object_utils(write_read_rand_sequence);

 	//sequence_item seq_item;
 	reset_sequence reset_sequence_h;
 	write_once_rand_sequence  write_once_rand_sequence_h;
 	read_once_rand_sequence   read_once_rand_sequence_h;

 	write_all_sequence	write_all_sequence_h;
 	read_all_sequence	read_all_sequence_h;


 	sequence_item seq_item_rand_tests;

 	bit full_check;
 	bit empty_check;

 	function new(string name = "write_read_rand_sequence");
 		super.new(name);
 	endfunction

 	task body();
 		seq_item_rand_tests = sequence_item::type_id::create("seq_item_rand_tests");

 		write_once_rand_sequence::reset_flag = 1'b1;
 		read_once_rand_sequence::reset_flag = 1'b1;
 		write_all_sequence::reset_flag = 1'b1;

 		reset_sequence_h = reset_sequence::type_id::create("reset_sequence_h");
 		write_once_rand_sequence_h = write_once_rand_sequence::type_id::create("write_once_rand_sequence_h");
 		read_once_rand_sequence_h = read_once_rand_sequence::type_id::create("read_once_rand_sequence_h");

 		write_all_sequence_h = write_all_sequence::type_id::create("write_all_sequence_h");
 		read_all_sequence_h = read_all_sequence::type_id::create("read_all_sequence_h");


 		reset_sequence_h.start(m_sequencer);
 		seq_item_rand_tests.randomize();

 		repeat(seq_item_rand_tests.randomized_number_of_tests) begin
 		 	assert(seq_item.randomize());
 		 	if(seq_item.operation == WRITE) begin
 		 		if(!full_check) begin
 		 			write_all_sequence_h.start(m_sequencer);
 		 			full_check = 1;
 		 		end
 		 		else begin
 		 			write_once_rand_sequence_h.start(m_sequencer);
 		 		end
 		 	end
 		 	else if(seq_item.operation == READ) begin
 		 		if(!empty_check) begin
 					read_all_sequence_h.start(m_sequencer);	
 		 			full_check = 1;
 		 		end
 		 		else begin
				read_once_rand_sequence_h.start(m_sequencer);
				end
			end
			else if(seq_item.operation == RESET) begin
				reset_sequence_h.start(m_sequencer);
 		 	end
 		end
 	endtask : body
 endclass