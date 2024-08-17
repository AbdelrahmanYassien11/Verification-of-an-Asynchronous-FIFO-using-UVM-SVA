class comparator extends uvm_component;
	`uvm_component_utils(comparator);

	sequence_item seq_item_actual;
	sequence_item seq_item_expected;

	uvm_comparer comparer_h;
	uvm_analysis_export 	#(sequence_item) analysis_actual_outputs;
	uvm_analysis_export 	#(sequence_item) analysis_expected_outputs;
	
	uvm_tlm_analysis_fifo 	#(sequence_item) fifo_actual_outputs;
	uvm_tlm_analysis_fifo 	#(sequence_item) fifo_expected_outputs;


	function new (string name = "comparator", uvm_component parent);
		super.new(name, parent);
	endfunction


	function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		fifo_expected_outputs = new(" fifo_expected_outputs", this);
		fifo_actual_outputs  = new(" fifo_actual_outputs", this);

		analysis_expected_outputs = new("analysis_expected_outputs", this);
		analysis_actual_outputs = new("analysis_actual_outputs", this);

		$display("my_compartor build phase");
	endfunction


	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);

		analysis_actual_outputs.connect(fifo_actual_outputs.analysis_export);
		analysis_expected_outputs.connect(fifo_expected_outputs.analysis_export);

		$display("my_compartor connect phase");
		
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			`uvm_info("COMPARATOR", "RUN PHASE", UVM_HIGH)	
			fifo_expected_outputs.get(seq_item_expected);
			`uvm_info("COMPARATOR",{"EXPECTED_SEQ_ITEM RECIEVED: ", 
						seq_item_expected.convert2string()}, UVM_HIGH)	
			fifo_actual_outputs.get(seq_item_actual);
			`uvm_info("COMPARATOR",{"actual_SEQ_ITEM RECIEVED: ", 
						seq_item_actual.convert2string()}, UVM_HIGH)

			if(seq_item_actual.do_compare(seq_item_expected, comparer_h)) begin
				`uvm_info("SCOREBOARD", "PASS", UVM_HIGH)
			end
			else begin
				`uvm_error("SCOREBOARD", "FAIL")
			end
		end
	endtask

endclass : comparator