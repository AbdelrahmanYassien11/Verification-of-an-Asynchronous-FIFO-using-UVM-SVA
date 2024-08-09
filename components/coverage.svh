 class coverage extends uvm_subscriber #(sequence_item);
 	`uvm_component_utils(coverage);
 	
 	//typedef uvm_subscriber #(my_first_sequence_item) this_type; //chipverify tlm_analysis_port, also to be used in the X_imp classes to be instantiated there
 			
 	//uvm_analysis_imp(my_first_sequence_item, my_first_subscriber); //giving the type of packet & the uvm_subscriber data type so he can instatntiate there
 	
 	virtual inf.TEST my_vif;

      logic                   rst_n;
	   bit   [FIFO_WIDTH-1:0]  data_in_cov;
      bit                     wr_en_cov;
      bit                     rd_en_cov;

      logic [FIFO_WIDTH-1:0]  data_out_expected_cov;
      logic                   wr_ack_expected_cov;
      logic                   overflow_expected_cov;
      logic                   underflow_expected_cov;
      logic                   almost_empty_expected_cov;
      logic                   empty_expected_cov;
      logic                   almost_full_expected_cov;
      logic                   full_expected_cov;
      logic                   half_full_expected_cov;


      STATE_e operation_cov;
      
      // operation covergroup
      covergroup OPERATION_covgrp;

         /* --------------------------------------------------------------------------------------Data Frame coverage of the current operation (either write or read)---------------------------------------------------------------------------------------------- */
      
         df_operation: coverpoint operation_cov iff (rst_n) {
            bins WRITE_Operation = {WRITE};
            bins READ_Operation =  {READ};
         }

         /* -------------------------------------------------------------------------------Data Transition coverage of the current operation (from write tor read and vice versa)---------------------------------------------------------------------------------------------- */
        
         dt_operation: coverpoint operation_cov iff (rst_n) {
            bins WRITE_READ_Transtion = (READ => WRITE);
            bins READ_WRITE_Transition =  (WRITE => READ);
         }

      endgroup

      // flags covergroup
      covergroup FLAGS_covgrp;

         /* --------------------------------------------------------------------------------------Data Transition coverage of different flags---------------------------------------------------------------------------------------------- */


         dt_full: coverpoint full_expected_cov iff (rst_n) {
            bins full_expected_off_on   = (0 => 1);
            bins full_expected_on_off   = (1 => 0);
         }

         dt_almost_full: coverpoint almost_full_expected_cov iff (rst_n) {
            bins almost_full_expected_off_on   = (0 => 1);
            bins almost_full_expected_on_off   = (1 => 0);
         }

         dt_overflow: coverpoint overflow_expected_cov iff (rst_n) {
            bins overflow_expected_off_on   = (0 => 1);
            bins overflow_expected_on_off   = (1 => 0);
         }

         dt_wr_ack: coverpoint wr_ack_expected_cov iff (rst_n) {
            bins wr_ack_expected_off_on   = (0 => 1);
            bins wr_ack_expected_on_off   = (1 => 0);
         }

         dt_empty: coverpoint empty_expected_cov iff (rst_n) {
            bins empty_expected_off_on   = (0 => 1);
            bins empty_expected_on_off   = (1 => 0);
         }

         dt_almost_empty: coverpoint almost_empty_expected_cov iff (rst_n) {
            bins almost_empty_expected_off_on   = (0 => 1);
            bins almost_empty_expected_on_off   = (1 => 0);
         }

         dt_underflow: coverpoint underflow_expected_cov iff (rst_n) {
            bins underflow_expected_off_on   = (0 => 1);
            bins underflow_expected_on_off   = (1 => 0);
         }

         /* --------------------------------------------------------------------------------------Data Frame coverage of different flags---------------------------------------------------------------------------------------------- */

         df_full: coverpoint full_expected_cov iff (rst_n) {
            bins full_expected_ON   = {1};
            bins full_expected_OFF   = {0};
         }

         df_almost_full: coverpoint almost_full_expected_cov iff (rst_n) {
            bins almost_full_expected_ON   = {1};
            bins almost_full_expected_OFF   = {0};
         }

         df_overflow: coverpoint overflow_expected_cov iff (rst_n) {
            bins overflow_expected_ON   = {1};
            bins overflow_expected_OFF   = {0};
         }

         df_wr_ack: coverpoint wr_ack_expected_cov iff (rst_n) {
            bins wr_ack_expected_ON   = {1};
            bins wr_ack_expected_OFF   = {0};
         }

         df_empty: coverpoint empty_expected_cov iff (rst_n) {
            bins empty_expected_ON   = {1};
            bins empty_expected_OFF   = {0};
         }

         df_almost_empty: coverpoint almost_empty_expected_cov iff (rst_n) {
            bins almost_empty_expected_ON   = {1};
            bins almost_empty_expected_OFF   = {0};
         }

         df_underflow: coverpoint underflow_expected_cov iff (rst_n) {
            bins underflow_expected_ON   = {1};
            bins underflow_expected_OFF   = {0};
         }

      endgroup


 	function void write (sequence_item t); //t is the packet

         rst_n          = t.rst_n;
         data_in_cov    = t.data_in;
         wr_en_cov      = t.wr_en;
         rd_en_cov      = t.rd_en;
         
         data_out_expected_cov      = t.data_out;
         wr_ack_expected_cov        = t.wr_ack;
         overflow_expected_cov      = t.overflow;
         underflow_expected_cov      = t.underflow;
         almost_empty_expected_cov  = t.almost_empty;
         empty_expected_cov         = t.empty;
         almost_full_expected_cov   = t.almost_full;
         full_expected_cov          = t.full;
         half_full_expected_cov     = t.half_full;

         operation_cov = t.operation;
         FLAGS_covgrp.sample();
         OPERATION_covgrp.sample();

 		`uvm_info ("COVERAGE", {"SAMPLE: ",t.convert2string}, UVM_HIGH)

 	endfunction
 			
 	function new(string name, uvm_component parent);
 	 	super.new(name, parent);
         OPERATION_covgrp = new;
         FLAGS_covgrp     = new;
 	endfunction

 	function void build_phase(uvm_phase phase);
 		super.build_phase(phase);
 		$display("coverage build_phase");
 		if(!uvm_config_db#(virtual inf.TEST)::get(this,"","my_vif",my_vif)) begin
			`uvm_fatal(get_full_name(),"Error");
		end
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("coverage run_phase");
	endtask : run_phase
 endclass