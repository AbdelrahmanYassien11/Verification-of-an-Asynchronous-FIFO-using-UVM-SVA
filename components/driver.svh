class driver extends  uvm_driver #(sequence_item);
 	`uvm_component_utils(driver);

 	sequence_item seq_item;
 	virtual inf.TEST my_vif;
 	virtual inf my_vif1;

	function new(string name = "driver", uvm_component parent);
 		super.new(name,parent);
 	endfunction

 	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(virtual inf.TEST)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
			`uvm_fatal(get_full_name(),"Error");
		end
		if(!uvm_config_db#(virtual inf)::get(this,"", "my_vif1", my_vif1)) begin
			`uvm_fatal(get_full_name(),"Error");
		end

		seq_item = sequence_item::type_id::create("seq_item");

		$display("my_driver build phase");
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		$display("my_driver connect phase");
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item_port.get_next_item(seq_item);
			my_vif1.generic_reciever(seq_item.rst_n, seq_item.data_in, seq_item.wr_en,
			 						seq_item.rd_en, seq_item.operation);

			seq_item_port.item_done();
		end

		$display("my_driver run phase");
	endtask

endclass