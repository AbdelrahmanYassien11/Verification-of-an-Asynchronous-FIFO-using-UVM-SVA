class write_read_rand_test extends base_test;
	`uvm_component_utils(write_read_rand_test)

	function new (string name =  "write_read_rand_test", uvm_component parent);
		super.new(name, parent);
	endfunction 

	function void build_phase(uvm_phase phase);
		base_sequence::type_id::set_type_override(write_read_rand_sequence::type_id::get());
		super.build_phase(phase);
	endfunction 

endclass