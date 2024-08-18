if [file exists "work"] {vdel -all}
vlib work
vlog -f dut.f +cover -covercells
vlog -f tb.f +cover -covercells
vopt top_test_uvm -o top_optimized +acc +cover=bcefsx+asynchronous_fifo(rtl)



vsim top_optimized -cover +UVM_TESTNAME=write_all_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
#coverage report -assert -details -zeros -verbose -output F:/ic_design/repos/FIFO_UVM/assertion_based_coverage_report.txt -append /.
#coverage report -detail -cvg -directive -comments -output Assertion_based_coverage_report.txt
#coverage report -detail -cvg -directive -comments -option -output functional_coverage_report.txt {} /FIFO_uvm_pkg/coverage/OPERATION_covgrp /FIFO_uvm_pkg/coverage/FLAGS_covgrp

#coverage attribute -name TESTNAME -value reset_test
#coverage save reset_test.ucdb



#vsim top_optimized -cover +UVM_TESTNAME=reset_write_read_all_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage report -assert -details -zeros -verbose -output assertion_based_coverage_report.txt -append /.
#coverage report -detail - zeros -cvg -directive -comments -output code_based_coverage_report.txt
#coverage report -detail -cvg -directive -comments -option -output functional_coverage_report.txt {} /FIFO_uvm_pkg/coverage/OPERATION_covgrp /FIFO_uvm_pkg/coverage/FLAGS_covgrp

#coverage attribute -name TESTNAME -value reset_write_read_all_test
#coverage save reset_write_read_all_test.ucdb



#vsim top_optimized -cover +UVM_TESTNAME=write_read_rand_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage report -assert -details -zeros -verbose -output assertion_based_coverage_report.txt -append /.
#coverage report -detail -cvg -directive -comments -output Assertion_based_coverage_report.txt
#coverage report -detail -cvg -directive -comments -output functional_coverage_report.txt {} /FIFO_pkg/coverage/OPERATION_covgrp /FIFO_pkg/coverage/FLAGS_covgrp

#coverage attribute -name TESTNAME -value write_read_rand_test
#coverage save write_read_rand_test.ucdb


#vcover merge FIFO.ucdb reset_write_read_all_test.ucdb write_read_rand_test.ucdb -out FIFO_tb.ucdb

#quit

#vcover report -output FIFO_coverage_report.txt FIFO_tb.ucdb -zeros -details -annotate -all