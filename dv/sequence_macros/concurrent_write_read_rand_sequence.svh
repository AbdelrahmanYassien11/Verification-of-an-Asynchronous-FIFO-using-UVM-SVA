class concurrent_write_read_rand_sequence extends base_sequence;
 	`uvm_object_utils(concurrent_write_read_rand_sequence);

 	reset_sequence reset_sequence_h;
 	concurrent_write_read_once_sequence concurrent_write_read_once_sequence_h;

 	sequence_item seq_item_rand_tests;

 	function new(string name = "concurrent_write_read_rand_sequence");
 		super.new(name);
 	endfunction

 	 task pre_body();
 		$display("start of pre_body task");
 		super.pre_body();
 	endtask : pre_body

 	task body();


 		concurrent_write_read_once_sequence::reset_flag = 1;

 		seq_item_rand_tests = new("seq_item_rand_tests");
 		//`uvm_create(seq_item_rand_tests)
 		seq_item_rand_tests.operation_rand_c.constraint_mode(0);

 		`uvm_do_on(reset_sequence_h, sequencer_h)

 		assert(seq_item_rand_tests.randomize());

 		repeat(seq_item_rand_tests.randomized_number_of_tests) begin
 			`uvm_do_on(concurrent_write_read_once_sequence_h, sequencer_h)
 		end
 	endtask : body

 endclass