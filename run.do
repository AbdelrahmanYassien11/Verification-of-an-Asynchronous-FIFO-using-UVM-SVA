if [file exists "work"] {vdel -all}
vlib work
vlog -f dut.f
vlog -f tb.f
vopt top_test_uvm -o top_optimized +acc +cover=sbfec
#+FIFO_DUT(rtl)
vsim top_optimized -coverage +UVM_TESTNAME=reset_test
coverage save FIFO_tb.ucdb -onexit
run -all
#quit -sim
#vcover report -file FIFO_coverage_report.txt memory_tb.ucdb -zeros -details -annotate -all
#+UVM_CONFIG_DB_TRACE=inf1
