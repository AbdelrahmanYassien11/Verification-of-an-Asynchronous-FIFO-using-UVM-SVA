 class env extends uvm_env;
 	
 	`uvm_component_utils(env);

 	agent agent_h;
 	scoreboard scoreboard_h;
 	coverage coverage_h;

 	virtual inf my_vif;

 	function new(string name = "environment", uvm_component parent);
		super.new(name,parent);
	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		agent_h = agent::type_id::create("agent_h",this);
		scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
		coverage_h = coverage::type_id::create("coverage_h", this);

		if(!uvm_config_db#(virtual inf)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
			`uvm_fatal(get_full_name(),"Error");
		end

		uvm_config_db#(virtual inf)::set(this,"agent_h", "my_vif", my_vif);
		uvm_config_db#(virtual inf)::set(this,"coverage_h", "my_vif", my_vif);
		uvm_config_db#(virtual inf)::set(this,"scoreboard_h", "my_vif", my_vif);

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
		//coverage_h.analysis_export.get_provided_to(list);
		//scoreboard_h.tlm_analysis_export.get_provided_to(list);
		$display("my_monitor end_of_elaboration_phase");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("env run phase");
	endtask

 endclass