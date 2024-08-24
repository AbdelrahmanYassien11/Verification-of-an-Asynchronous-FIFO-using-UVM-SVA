 class sequencer extends uvm_sequencer#(sequence_item);
 	`uvm_component_utils(sequencer);


	function new(string name = "sequencer", uvm_component parent);
		super.new (name, parent);
	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		$display("sequencer build phase");
	endfunction

	function void connect_phase(uvm_phase phase); //parrallel
		super.connect_phase(phase);
		$display("sequencer connect phase");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("sequencer run phase");
	endtask

 endclass
