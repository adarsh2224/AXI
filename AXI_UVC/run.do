vlib work
vlog +incdir+/home/adarshrv/Downloads/UVM/src +define+UVM_NO_DPI top.sv

vsim -assertdebug -novopt -suppress 12110 top +UVM_TESTNAME=axi_n_wr_n_rd_test
add wave /top/axi_assertion_i/AXI4_ERRM_AWID_STABLE
add wave /top/axi_assertion_i/AXI4_ERRM_AWID_X
do wave.do

run -all
