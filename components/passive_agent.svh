class passive_agent extends uvm_agent;
 	`uvm_component_utils(passive_agent);

 	passive_agent_config passive_agent_config_h;

 	sequencer sequencer_h;
  	driver driver_h;

  	outputs_monitor outputs_monitor_h;

  	uvm_analysis_port #(sequence_item) tlm_analysis_port_outputs;

  	uvm_port_list list;

  	virtual inf my_vif;

  	function new (string name = "passive_agent", uvm_component parent);
   		super.new(name, parent);
  	endfunction


  	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(passive_agent_config)::get(this,"","config",passive_agent_config_h)) begin
			`uvm_fatal("passive_agent" , "Failed to get passive_agent_config object");
		end

			is_active = passive_agent_config_h.get_is_passive();

		if (get_is_active() == UVM_ACTIVE) begin
			sequencer_h = sequencer::type_id::create("sequencer_h",this);
			driver_h = driver::type_id::create("driver_h",this);	
		end		

		outputs_monitor_h = outputs_monitor::type_id::create("outputs_monitor_h", this);

		uvm_config_db#(virtual inf)::set(this,"driver_h", "my_vif", passive_agent_config_h.passive_agent_config_my_vif);
		uvm_config_db#(virtual inf)::set(this,"outputs_monitor_h", "my_vif", passive_agent_config_h.passive_agent_config_my_vif);

 		tlm_analysis_port_outputs = new("tlm_analysis_port_outputs", this);

		$display("my_passive_agent build phase");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		outputs_monitor_h.tlm_analysis_port.connect(tlm_analysis_port_outputs);

		if (get_is_active() == UVM_ACTIVE)
			driver_h.seq_item_port.connect(sequencer_h.seq_item_export);

		$display("my_passive_agent connect phase");
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		//tlm_analysis_port.get_connected_to(list);
		//tlm_analysis_port.get_provided_to(list);
		$display("my_monitor end_of_elaboration_phase");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("my_passive_agent run phase");
	endtask


 endclass