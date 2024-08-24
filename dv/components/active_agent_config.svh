class active_agent_config;


	virtual inf active_agent_config_my_vif;

	protected uvm_active_passive_enum is_active;

	function new (virtual inf active_agent_config_my_vif, uvm_active_passive_enum is_active);
		this.active_agent_config_my_vif = active_agent_config_my_vif;
		this.is_active = is_active;
	endfunction : new


	function uvm_active_passive_enum get_is_active ();
		return is_active;
	endfunction : get_is_active

endclass : active_agent_config
