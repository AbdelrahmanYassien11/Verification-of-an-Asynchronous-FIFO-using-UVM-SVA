
`ifdef QUESTA
virtual class base_test extends uvm_test;
`else 
class base_test extends uvm_test;
`endif


   env       env_h;
   sequencer sequencer_h;
   
   virtual interface inf my_vif;

   function void build_phase(uvm_phase phase);
      env_h = env::type_id::create("env_h",this);
      // Get the virtual interface from the configuration database
      if(!uvm_config_db#(virtual inf)::get(this,"","my_vif",my_vif)) begin //to fix the get warning of having no container to return to
         `uvm_fatal(get_full_name(),"Error");
      end

        // Set the virtual interface into the environment
      uvm_config_db#(virtual inf)::set(this, "env_h", "my_vif", my_vif);

      $display("write_test build phase");
   endfunction : build_phase

   function void end_of_elaboration_phase(uvm_phase phase);
      sequencer_h = env_h.agent_h.sequencer_h;
   endfunction : end_of_elaboration_phase

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

endclass
   