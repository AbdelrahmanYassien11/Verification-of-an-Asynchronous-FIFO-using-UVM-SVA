
class outputs_monitor extends uvm_monitor;
  	`uvm_component_utils(outputs_monitor);

  	virtual inf my_vif;


  	uvm_analysis_port #(sequence_item) tlm_analysis_port;


  	function new (string name = "outputs_monitor", uvm_component parent);
    	super.new(name,parent);
  	endfunction
			
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(virtual inf)::get(this,"", "my_vif", my_vif)) begin
			`uvm_fatal(get_full_name(),"Error");
		end


		tlm_analysis_port = new("tlm_analysis_port", this);

		$display("my_monitor build phase");
	endfunction


	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		my_vif.outputs_monitor_h = this;
		$display("my_monitor connect phase");
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		//tlm_analysis_port.get_connected_to(list);
		//tlm_analysis_port.get_provided_to(list);
		$display("my_monitor end_of_elaboration_phase");
	endfunction



	virtual function void write_to_monitor (input bit irrst_n, input bit iwrst_n, input bit [FIFO_WIDTH-1:0] idata_in, input bit iw_en, 
											input bit ir_en, input logic [FIFO_WIDTH-1:0] idata_out, input logic iempty,
											input logic ifull, input STATE_e ioperation);

		sequence_item seq_item;

		seq_item = new("seq_item");

			seq_item.rrst_n 			= irrst_n;
			seq_item.wrst_n 			= iwrst_n;
			seq_item.data_in 			= idata_in;
			seq_item.w_en 				= iw_en;
			seq_item.r_en 				= ir_en;

			$display(" time = %0t dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa_out =  %0d",$time(), idata_out);
			seq_item.data_out 			= idata_out;
			seq_item.empty 				= iempty;
			seq_item.full				= ifull;

			seq_item.operation			= ioperation;

			tlm_analysis_port.write(seq_item);

	endfunction : write_to_monitor

endclass