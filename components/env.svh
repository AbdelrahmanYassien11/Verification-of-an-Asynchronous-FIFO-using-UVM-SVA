 class env extends uvm_env;
 	
 	`uvm_component_utils(env);

 	env_config env_config_h;

 	active_agent_config active_agent_config_h;
 	passive_agent_config passive_agent_config_h;

 	active_agent active_WRITE_agent_h;
 	active_agent active_READ_agent_h;

 	passive_agent passive_agent_h;

 	scoreboard scoreboard_h;
 	coverage coverage_h;

 	uvm_port_list list;

 	virtual inf my_vif;

 	function new(string name = "environment", uvm_component parent);
		super.new(name,parent);
	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);



		if(!uvm_config_db#(env_config)::get(this,"","config",env_config_h)) begin
			`uvm_fatal(get_full_name(),"Failed to get env configuration");
		end

		active_agent_config_h = new(.active_agent_config_my_vif(env_config_h.env_config_my_vif), .is_active(UVM_ACTIVE));
		passive_agent_config_h = new(.passive_agent_config_my_vif(env_config_h.env_config_my_vif), .is_passive(UVM_PASSIVE));


		uvm_config_db#(active_agent_config)::set(this,"active_WRITE_agent_h", "config", active_agent_config_h);
		uvm_config_db#(active_agent_config)::set(this,"active_READ_agent_h", "config", active_agent_config_h);
		//uvm_config_db#(passive_agent_config)::set(this,"passive_agent_h", "config", passive_agent_config_h);

		//uvm_config_db#(virtual inf)::set(this,"agent_h", "my_vif", my_vif);
		uvm_config_db#(virtual inf)::set(this,"coverage_h", "my_vif", my_vif);
		uvm_config_db#(virtual inf)::set(this,"scoreboard_h", "my_vif", my_vif);

		active_WRIE_agent_h = active_agent::type_id::create("active_WRITE_agent_h",this);
		active_READ_agent_h = active_agent::type_id::create("active_READ_agent_h",this);

		//passive_agent_h = passive_agent::type_id::create("passive_agent_h",this);

		scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
		coverage_h = coverage::type_id::create("coverage_h", this);

		$display("env build phase");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		active_WRITE_agent_h.tlm_analysis_port_outputs.connect(coverage_h.analysis_export);
		active_READ_agent_h.tlm_analysis_port_outputs.connect(coverage_h.analysis_export);

		active_WRITE_agent_h.tlm_analysis_port_inputs.connect(scoreboard_h.analysis_export_inputs);
		active_READ_agent_h.tlm_analysis_port_inputs.connect(scoreboard_h.analysis_export_inputs);

		active_agent_WRITE_h.tlm_analysis_port_outputs.connect(scoreboard_h.analysis_export_outputs);
		active_agent_READ_h.tlm_analysis_port_outputs.connect(scoreboard_h.analysis_export_outputs);
		//passive_agent_h.tlm_analysis_port_outputs.connect(scoreboard_h.analysis_export_outputs);
		$display("envconnect phase");
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		scoreboard_h.set_report_verbosity_level_hier(UVM_HIGH);
		coverage_h.analysis_export.get_provided_to(list);   // This imp/export provided for what port/export
		`uvm_info(get_name(), $sformatf("%p", list), UVM_LOW)
		scoreboard_h.analysis_export_inputs.get_provided_to(list);
		`uvm_info(get_name(), $sformatf("%p", list), UVM_LOW)
		scoreboard_h.analysis_export_outputs.get_provided_to(list);
		`uvm_info(get_name(), $sformatf("%p", list), UVM_LOW)
		$display("FINISHED GET_PROVIDED_TO");
		coverage_h.analysis_export.get_connected_to(list); // This port/export connected to what imp/export, as in what comes after it
		`uvm_info(get_name(), $sformatf("%p", list), UVM_LOW)
		scoreboard_h.analysis_export_inputs.get_connected_to(list);
		`uvm_info(get_name(), $sformatf("%p", list), UVM_LOW)
		scoreboard_h.analysis_export_outputs.get_connected_to(list);
		`uvm_info(get_name(), $sformatf("%p", list), UVM_LOW)
		$display("my_monitor end_of_elaboration_phase");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("env run phase");
	endtask

 endclass