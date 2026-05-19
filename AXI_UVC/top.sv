`timescale 1ns/1ns;
`include "uvm_pkg.sv"
import uvm_pkg::*;

`include "axi_common.sv"
`include "axi_intf.sv"
`include "axi_assertion.sv"
`include "axi_tx.sv"
`include "axi_drv.sv"
`include "axi_mon.sv"
`include "axi_sqr.sv"
`include "axi_cov.sv"
`include "axi_responder.sv"
`include "axi_master_agent.sv"
`include "axi_slave_agent.sv"
`include "axi_seq_lib.sv"
`include "axi_sbd1.sv"
`include "axi_env.sv"
`include "test_lib.sv"
module top;
reg clk,rst;
axi_intf pif(clk,rst);

initial begin
clk = 0;
forever #5 clk=~clk;
end

initial begin
uvm_resource_db#(virtual axi_intf)::set("GLOBAL","AXI_VIF",pif,null);
rst=1;
repeat(2)@(posedge clk);
rst=0;
end

axi_assertion axi_assertion_i(
.aclk(pif.aclk), 
.arst(pif.arst),
.awaddr(pif.arst),
.awid(pif.awid),
.awlen(pif.awlen), 
.awburst(pif.awburst), 
.awsize(pif.awsize), 
.awprot(pif.awprot), 
.awlock(pif.awlock), 
.awcache(pif.awcache), 
.awvalid(pif.awvalid), 
.awready(pif.awready), 
.wdata(pif.wdata), 
.wstrb(pif.wstrb), 
.wid(pif.wid), 
.wready(pif.wready), 
.wvalid(pif.wvalid), 
.wlast(pif.wlast), 
.bid(pif.bid), 
.bready(pif.bready), 
.bvalid(pif.bvalid), 
.bresp(pif.bresp), 
.araddr(pif.araddr), 
.arid(pif.arid), 
.arlen(pif.arlen), 
.arburst(pif.arburst), 
.arsize(pif.arsize), 
.arprot(pif.arprot), 
.arlock(pif.arlock), 
.arcache(pif.arcache), 
.arvalid(pif.arvalid), 
.arready(pif.arready), 
.rdata(pif.rdata), 
.rid(pif.rid), 
.rready(pif.rready), 
.rvalid(pif.rvalid), 
.rlast(pif.rlast), 
.rresp(pif.rresp)
);



initial begin 
run_test("axi_wr_rd_test");
end
initial begin
$fsdbDumpfile("axi.fsdb");
$fsdbDumpvars();
end
endmodule
