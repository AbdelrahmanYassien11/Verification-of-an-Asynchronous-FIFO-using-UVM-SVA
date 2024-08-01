package package_FIFO_tb;

	typedef enum {BEFORE_RESET, READ , WRITE} STATE_e;

   parameter  TESTS_WRITE = 520;
   parameter  TESTS_READ = 520;

   localparam RX_ON = 1'b1, RX_OFF = 1'b0, TX_ON = 1'b1, TX_OFF = 1'b0;

   parameter FIFO_WIDTH = 8;
   parameter FIFO_DEPTH = 16;
   parameter FIFO_SIZE = 512;

   //int TEST_randomized;


   logic full_expected;
   logic wr_ack_expected;
   logic almost_full_expected;
   logic overflow_expected;
   logic half_full_expected;

   logic empty_expected;
   logic almost_empty_expected;
   logic underflow_expected;


   int       error_count; // 32-bit unsigned
   int       correct_count; // 32-bit unsigned

class RAM_inputs;
   parameter FIFO_WIDTH = 8;
   parameter FIFO_DEPTH = 16;
   rand STATE_e state;
   // the values that will be randomized
   rand bit [16-1:0] data_to_write;
   bit rst_n;
   //rand bit operation;
   STATE_e operation_cov;
   rand byte unsigned TESTS_randomized;

   logic full_expected_cov;
   logic wr_ack_expected_cov;
   logic almost_full_expected_cov;
   logic overflow_expected_cov;
   logic half_full_expected_cov;

   logic empty_expected_cov;
   logic almost_empty_expected_cov;
   logic underflow_expected_cov;
   
   /*constraint operation_c {
      operation dist {1:/5, 0:/95};
   }*/


   /*constraint reset_c {
      reset dist {1:/5, 0:/95};
   } */ 

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

         dt_half_full: coverpoint half_full_expected_cov iff(rst_n){
            bins half_full_expected_off_on    = (0 => 1);
            bins half_full_expected_on_off    = (1 => 0);
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

         df_half_full: coverpoint half_full_expected_cov iff (rst_n) {
            bins half_full_expected_ON = {1};
            bins half_full_expected_OFF = {0};
         }

      endgroup

      function new();

         OPERATION_covgrp = new;
         FLAGS_covgrp     = new;

      endfunction

endclass


endpackage : package_FIFO_tb

