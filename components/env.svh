 class env extends uvm_env;
 	
 	`uvm_component_utils(env);

 	env_config env_config_h;
 	agent_config agent_config_h;

 	agent agent_h;
 	scoreboard scoreboard_h;
 	coverage coverage_h;

 	uvm_port_list list;

 	virtual inf.TEST my_vif;

 	function new(string name = "environment", uvm_component parent);
		super.new(name,parent);
	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);



		if(!uvm_config_db#(env_config)::get(this,"","config",env_config_h)) begin
			`uvm_fatal(get_full_name(),"Failed to get env configuration");
		end

		agent_config_h = new(.agent_config_my_vif(env_config_h.env_config_my_vif), .is_active(UVM_ACTIVE));

		uvm_config_db#(agent_config)::set(this,"agent_h", "config", agent_config_h);

		//uvm_config_db#(virtual inf.TEST)::set(this,"agent_h", "my_vif", my_vif);
		uvm_config_db#(virtual inf.TEST)::set(this,"coverage_h", "my_vif", my_vif);
		uvm_config_db#(virtual inf.TEST)::set(this,"scoreboard_h", "my_vif", my_vif);

		agent_h = agent::type_id::create("agent_h",this);
		scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
		coverage_h = coverage::type_id::create("coverage_h", this);

		$display("env build phase");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent_h.tlm_analysis_port_inputs.connect(coverage_h.analysis_export);
		agent_h.tlm_analysis_port_outputs.connect(coverage_h.analysis_export);

		agent_h.tlm_analysis_port_inputs.connect(scoreboard_h.analysis_export_inputs);
		agent_h.tlm_analysis_port_outputs.connect(scoreboard_h.analysis_export_outputs);
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
		coverage_h.analysis_export.get_connected_to(list); // This port/export connected for what imp/export
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