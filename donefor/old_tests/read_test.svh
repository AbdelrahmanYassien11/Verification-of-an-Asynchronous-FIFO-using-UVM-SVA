class read_test extends uvm_test;
 	`uvm_component_utils(read_test);
 	
 	virtual interface inf my_vif;

 	read_once_sequence read_once_sequence_h;

 	env env_h;
 

	function new(string name = "test1", uvm_component parent);
 	 	super.new(name, parent);
 	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_h = env::type_id::create("env_h",this);
		read_once_sequence_h = read_once_sequence::type_id::create("read_once_sequence_h",this);


		if(!uvm_config_db#(virtual inf)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
			`uvm_fatal(get_full_name(),"Error");
		end

		uvm_config_db#(virtual inf)::set(this,"env_h", "my_vif", my_vif);

		$display("my_test build phase");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("my_test connect phase");
	endfunction

	task run_phase(uvm_phase phase);

		super.run_phase(phase);
		phase.raise_objection(this);
		read_once_sequence_h.start(env_h.agent_h.sequencer_h);
		phase.drop_objection(this);
		$display("my_test run phase");

	endtask

 endclass