if [file exists "work"] {vdel -all}
vlib work
vlog -f dut.f
vlog -f tb.f
vopt top -o top_optimized +acc +cover=sbfec+FIFO(rtl)



#vsim top_optimized -coverage +UVM_TESTNAME=reset_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage report -assert -detail -verbose -output F:/ic_design/repos/FIFO_UVM/assertion_based_coverage_report.txt -append /.
#coverage report -detail -cvg -directive -comments -output Assertion_based_coverage_report.txt
#coverage report -detail -cvg -directive -comments -option -output functional_coverage_report.txt {} /FIFO_uvm_pkg/coverage/OPERATION_covgrp /FIFO_uvm_pkg/coverage/FLAGS_covgrp

#coverage attribute -name TESTNAME -value reset_test
#coverage save reset_test.ucdb



#vsim top_optimized -coverage +UVM_TESTNAME=reset_write_read_all_test
#set NoQuitOnFinish 1
#onbreak {resume}
#log /* -r
#run -all
#coverage report -assert -detail -verbose -output F:/ic_design/repos/FIFO_UVM/assertion_based_coverage_report.txt -append /.
#coverage report -detail -cvg -directive -comments -output Assertion_based_coverage_report.txt
#coverage report -detail -cvg -directive -comments -option -output functional_coverage_report.txt {} /FIFO_uvm_pkg/coverage/OPERATION_covgrp /FIFO_uvm_pkg/coverage/FLAGS_covgrp

#coverage attribute -name TESTNAME -value reset_write_read_all_test
#coverage save reset_write_read_all_test.ucdb



vsim top_optimized -coverage +UVM_TESTNAME=write_read_rand_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage report -assert -detail -verbose -output F:/ic_design/repos/FIFO_UVM/assertion_based_coverage_report.txt -append /.
coverage report -detail -cvg -directive -comments -output Assertion_based_coverage_report.txt
coverage report -detail -cvg -directive -comments -option -output functional_coverage_report.txt {} /FIFO_uvm_pkg/coverage/OPERATION_covgrp /FIFO_uvm_pkg/coverage/FLAGS_covgrp

coverage attribute -name TESTNAME -value write_read_rand_test
coverage save write_read_rand_test.ucdb


#vcover merge FIFO.ucdb reset_write_read_all_test.ucdb write_read_rand_test.ucdb -out FIFO_tb.ucdb

#quit

#vcover report -file FIFO_coverage_report.txt FIFO_tb.ucdb -zeros -details -annotate -all