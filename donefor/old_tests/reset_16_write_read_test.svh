class reset_16_write_read_test extends base_test;
    `uvm_component_utils(reset_16_write_read_test)
    
    reset_16_write_read_sequence reset_16_write_read_sequence_h;


    function new(string name = "reset_16_write_read_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        reset_16_write_read_sequence_h = reset_16_write_read_sequence::type_id::create("reset_16_write_read_sequence_h");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("write_test connect phase");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        phase.raise_objection(this);

        // Start the reset_16_write_read_sequence
        if (reset_16_write_read_sequence_h == null) begin
            `uvm_error(get_type_name(), "reset_16_write_read_sequence_h is null")
            phase.drop_objection(this);
            return;
        end

        reset_16_write_read_sequence_h.start(env_h.agent_h.sequencer_h);
        //reset_16_write_read_sequence_h.wait_for_sequence_state(UVM_FINISHED);

        phase.drop_objection(this);

        $display("write_test run phase");
    endtask
endclass