
//`ifdef QUESTA
//virtual class base_test extends uvm_test;
//`else 
class base_test extends uvm_test;
//`endif

   virtual inf my_vif;

   env_config env_config_h;

   env       env_h;
   sequencer sequencer_h;
   base_sequence base_sequence_h;
   
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

   virtual function void build_phase(uvm_phase phase);


      if(!uvm_config_db#(virtual inf)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
         `uvm_fatal(get_full_name(),"Error");
      end

      env_config_h = new(.env_config_my_vif(my_vif));

        // Set the virtual interface into the environment
      uvm_config_db#(env_config)::set(this, "env_h", "config", env_config_h);

      env_h = env::type_id::create("env_h",this);
      base_sequence_h = base_sequence::type_id::create("base_sequence_h");

      $display("base_test build phase");
   endfunction : build_phase


   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      $display("my_test connect phase");
    endfunction


    
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      sequencer_h = env_h.agent_h.sequencer_h;
   endfunction : end_of_elaboration_phase



   virtual task run_phase(uvm_phase phase);

      super.run_phase(phase);
      phase.raise_objection(this);
      base_sequence_h.start(sequencer_h);
      phase.drop_objection(this);
      $display("my_test run phase");

   endtask

endclass
   