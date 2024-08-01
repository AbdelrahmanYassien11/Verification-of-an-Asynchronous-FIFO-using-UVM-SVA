class reset_write_read_test extends base_test;
    `uvm_component_utils(reset_write_read_test)


    
    reset_write_read_sequence reset_write_read_sequence_h;

    function new(string name = "reset_write_read_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        reset_write_read_sequence_h = reset_write_read_sequence::type_id::create("reset_write_read_sequence_h");


    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        /*if (env_h == null || env_h.agent_h == null || env_h.agent_h.sequencer_h == null) begin
            `uvm_fatal(get_type_name(), "Environment or sequencer handle is null.")
        end*/
        $display("write_test connect phase");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);

        // Start the reset_write_read_sequence
        if (reset_write_read_sequence_h == null) begin
            `uvm_error(get_type_name(), "reset_write_read_sequence_h is null")
            phase.drop_objection(this);
            return;
        end

        reset_write_read_sequence_h.start(env_h.agent_h.sequencer_h);
        //reset_write_read_sequence_h.wait_for_sequence_state(UVM_FINISHED);

        phase.drop_objection(this);

        $display("write_test run phase");
    endtask
endclass
