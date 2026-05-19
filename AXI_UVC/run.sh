#compilation and elaboration => simv
vcs -sverilog -full64 -debug_access+all -kdb \
-l comp.log \
+incdir+/home/adarshrv/Downloads/UVM/src \
+define+UVM_NO_DPI \
top.sv

#simulation
./simv +ntb_random_seed_automatic +UVM_TESTNAME=axi_n_wr_n_rd_test -l sim.log &
#./simv +ntb_random_seed=4210281424 +UVM_TESTNAME=axi_n_wr_n_rd_test -l sim.log +UVM_VERBOSITY=UVM_LOW &

