 class coverage extends uvm_subscriber #(sequence_item);
 	`uvm_component_utils(coverage);
 	
 	//typedef uvm_subscriber #(my_first_sequence_item) this_type; //chipverify tlm_analysis_port, also to be used in the X_imp classes to be instantiated there
 			
 	//uvm_analysis_imp(my_first_sequence_item, my_first_subscriber); //giving the type of packet & the uvm_subscriber data type so he can instatntiate there
 	
 	virtual inf my_vif;

      logic                   rrst_n;
      logic                   wrst_n;
	   bit   [FIFO_WIDTH-1:0]  data_in_cov;
      bit                     w_en_cov;
      bit                     r_en_cov;

      logic [FIFO_WIDTH-1:0]  data_out_expected_cov;
      logic                   empty_expected_cov;
      logic                   full_expected_cov;



      STATE_e operation_cov;

      // operation covergroup
      covergroup OPERATION_covgrp;

         /* --------------------------------------------------------------------------------------Data Frame coverage of the current operation (either write or read)---------------------------------------------------------------------------------------------- */
      
         df_operation: coverpoint operation_cov  {
            bins WRITE_Operation = {WRITE};
            bins WRITE_Operation_for_FIFO_SIZE = (WRITE [* 8]);
            bins READ_Operation =  {READ};
            bins READ_Operation_for_FIFO_SIZE = (READ [* 8]);
            bins RESET_Operation = {RESET};

         }

         /* -------------------------------------------------------------------------------Data Transition coverage of the current operation (from write tor read and vice versa)---------------------------------------------------------------------------------------------- */
        
         dt_operation: coverpoint operation_cov  {
            bins WRITE_READ_Transtion     = (READ => WRITE);
            bins READ_WRITE_Transition    = (WRITE => READ);
            bins WRITE_RESET_Transition   = (WRITE => RESET);
            bins READ_RESET_Transition    = (READ => RESET);
            bins RESET_WRITE_Transition   = (RESET => WRITE);
            bins RESET_READ_Transition    = (RESET => READ);
         }

      endgroup

      // INPUTS covergroup
      covergroup INPUTS_covgrp;

         /* ---------------------------------------------------------------------------------------------------Data Frame coverage of the DATA_IN --------------------------------------------------------------------------------------------------------------------------------- */
      
         df_data_in: coverpoint data_in_cov iff (rrst_n && wrst_n && r_en_cov) {
            bins DATA_IN_Values_others = {['hFE:'h00]};
            bins DATA_IN_Values_zeros =  {'h00};
            bins DATA_IN_Values_ones = {'hFF};
         }

         /* ------------------------------------------------------------------------------------------------------Data Frame coverage of the WRITE_ENABLE---------------------------------------------------------------------------------------------------------------------- */
      
         df_w_en: coverpoint w_en_cov iff (rrst_n && wrst_n) {
            bins WRITE_On = {1};
            bins WRITE_Off =  {0};
            bins WRITE_ON_for_FIFO_SIZE = (1 [* 8]);
         }

         /* ----------------------------------------------------------------------------------------------------Data Transition coverage of the WRITE_ENABLE------------------------------------------------------------------------------------------------------------ */
        
         dt_w_en: coverpoint w_en_cov iff (rrst_n && wrst_n) {
            bins WRITE_OFF_ON       = (0 => 1);
            bins WRITE_ON_OFF       = (1 => 0);
            bins WRITE_ON_ON        = (1 => 1);
            bins WRITE_OFF_OFF      = (0 => 0);
         }

         /* -------------------------------------------------------------------------------------------------------Data Frame coverage of the READ_ENABLE----------------------------------------------------------------------------------------------------------------- */
      
         df_r_en: coverpoint r_en_cov iff (rrst_n && wrst_n) {
            bins READ_On = {1};
            bins READ_Off =  {0};
            bins READ_ON_for_FIFO_SIZE = (1 [* 8]);
         }

         /* -----------------------------------------------------------------------------------------------------Data Transition coverage of the READ_ENABLE-------------------------------------------------------------------------------------------------------- */
        
         dt_r_en: coverpoint r_en_cov iff (rrst_n && wrst_n) {
            bins READ_OFF_ON       = (0 => 1);
            bins READ_ON_OFF       = (1 => 0);
            bins READ_ON_ON        = (1 => 1);
            bins READ_OFF_OFF      = (0 => 0);
         }
      endgroup



      // flags covergroup
      covergroup FLAGS_covgrp;

         /* --------------------------------------------------------------------------------------Data Transition coverage of different flags---------------------------------------------------------------------------------------------- */


         dt_full: coverpoint full_expected_cov iff (rrst_n && wrst_n) {
            bins full_expected_off_on   = (0 => 1);
            bins full_expected_on_off   = (1 => 0);
         }

         dt_empty: coverpoint empty_expected_cov iff (rrst_n && wrst_n) {
            bins empty_expected_off_on   = (0 => 1);
            bins empty_expected_on_off   = (1 => 0);
         }

         /* --------------------------------------------------------------------------------------Data Frame coverage of different flags---------------------------------------------------------------------------------------------- */

         df_full: coverpoint full_expected_cov iff (rrst_n && wrst_n) {
            bins full_expected_ON   = {1};
            bins full_expected_OFF   = {0};
         }

         df_empty: coverpoint empty_expected_cov iff (rrst_n && wrst_n) {
            bins empty_expected_ON   = {1};
            bins empty_expected_OFF   = {0};
         }
      endgroup


 	function void write (sequence_item t); //t is the packet

         rrst_n         =  t.rrst_n;
         wrst_n          = t.wrst_n;
         data_in_cov    = t.data_in;
         w_en_cov      = t.w_en;
         r_en_cov      = t.r_en;
      
         data_out_expected_cov      = t.data_out;
         empty_expected_cov         = t.empty;
         full_expected_cov          = t.full;


         operation_cov = t.operation;
         FLAGS_covgrp.sample();
         OPERATION_covgrp.sample();
         INPUTS_covgrp.sample();

 		`uvm_info ("COVERAGE", {"SAMPLE: ",t.convert2string}, UVM_HIGH)

 	endfunction
 			
 	function new(string name, uvm_component parent);
 	 	super.new(name, parent);
         OPERATION_covgrp = new;
         FLAGS_covgrp     = new;
         INPUTS_covgrp    = new;
 	endfunction

 	function void build_phase(uvm_phase phase);
 		super.build_phase(phase);
 		$display("coverage build_phase");
 		if(!uvm_config_db#(virtual inf)::get(this,"","my_vif",my_vif)) begin
			`uvm_fatal(get_full_name(),"Error");
		end
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("coverage run_phase");
	endtask : run_phase
 endclass