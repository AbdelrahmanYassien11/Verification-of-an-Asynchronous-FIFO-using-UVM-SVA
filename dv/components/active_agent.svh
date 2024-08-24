class active_agent extends uvm_agent;
 	`uvm_component_utils(active_agent);

 	active_agent_config active_agent_config_h;

 	sequencer sequencer_h;
  	driver driver_h;

  	inputs_monitor inputs_monitor_h;

  	uvm_analysis_port #(sequence_item) tlm_analysis_port_inputs;

  	uvm_port_list list;

  	virtual inf my_vif;

  	function new (string name = "active_agent", uvm_component parent);
   		super.new(name, parent);
  	endfunction


  	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(active_agent_config)::get(this,"","active_config",active_agent_config_h)) begin
			`uvm_fatal("active_agent" , "Failed to get active_agent_config object");
		end

			is_active = active_agent_config_h.get_is_active();

		if (get_is_active() == UVM_ACTIVE) begin
			sequencer_h = sequencer::type_id::create("sequencer_h",this);
			driver_h = driver::type_id::create("driver_h",this);	
		end		

		inputs_monitor_h = inputs_monitor::type_id::create("inputs_monitor_h", this);

		uvm_config_db#(virtual inf)::set(this,"driver_h", "my_vif", active_agent_config_h.active_agent_config_my_vif);
		uvm_config_db#(virtual inf)::set(this,"inputs_monitor_h", "my_vif", active_agent_config_h.active_agent_config_my_vif);

 		tlm_analysis_port_inputs = new("tlm_analysis_port_inputs", this);

		$display("my_active_agent build phase");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		inputs_monitor_h.tlm_analysis_port.connect(tlm_analysis_port_inputs);

		if (get_is_active() == UVM_ACTIVE)
			driver_h.seq_item_port.connect(sequencer_h.seq_item_export);

		$display("my_active_agent connect phase");
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		//tlm_analysis_port.get_connected_to(list);
		//tlm_analysis_port.get_provided_to(list);
		$display("my_monitor end_of_elaboration_phase");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("my_active_agent run phase");
	endtask


 endclass