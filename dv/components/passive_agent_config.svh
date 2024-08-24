class passive_agent_config;


	virtual inf passive_agent_config_my_vif;

	protected uvm_active_passive_enum is_passive;

	function new (virtual inf passive_agent_config_my_vif, uvm_active_passive_enum is_passive);
		this.passive_agent_config_my_vif = passive_agent_config_my_vif;
		this.is_passive = is_passive;
	endfunction : new


	function uvm_active_passive_enum get_is_passive ();
		return is_passive;
	endfunction : get_is_passive

endclass : passive_agent_config