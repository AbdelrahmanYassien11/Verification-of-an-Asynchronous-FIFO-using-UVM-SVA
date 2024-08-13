class agent_config;


	virtual inf agent_config_my_vif;

	protected uvm_active_passive_enum is_active;

	function new (virtual inf agent_config_my_vif, uvm_active_passive_enum is_active);
		this.agent_config_my_vif = agent_config_my_vif;
		this.is_active = is_active;
	endfunction : new


	function uvm_active_passive_enum get_is_active ();
		return is_active;
	endfunction : get_is_active

endclass : agent_config
