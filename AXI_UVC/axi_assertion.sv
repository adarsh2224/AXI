module axi_assertion( aclk, arst, awaddr, awid, awlen, awburst, awsize, awprot, awlock, awcache, awvalid, awready, wdata, wstrb, wid, wready, wvalid, wlast, bid, bready, bvalid, bresp, araddr, arid, arlen, arburst, arsize, arprot, arlock, arcache, arvalid, arready, rdata, rid, rready, rvalid, rlast, rresp);


//write
input aclk, arst;
input [`ADDR_SIZE-1:0] awaddr;
input [3:0]awid;
input [3:0]awlen;
input [1:0]awburst;
input [2:0]awsize;
input [2:0]awprot;
input [1:0]awlock;
input [1:0]awcache;
input awvalid;
input awready;
input [`DATA_SIZE-1:0]wdata;
input [`STRB_SIZE-1:0]wstrb;
input [3:0]wid;
input wready;
input wvalid;
input wlast;
input [3:0]bid;
input bready;
input bvalid;
input [1:0]bresp;

//read
input [`ADDR_SIZE-1:0] araddr;
input [3:0]arid;
input [3:0]arlen;
input [1:0]arburst;
input [2:0]arsize;
input [2:0]arprot;
input [1:0]arlock;
input [1:0]arcache;
input arvalid;
input arready;
input [`DATA_SIZE-1:0]rdata;
input [3:0]rid;
input rready;
input rvalid;
input rlast;
input [1:0]rresp;

property AXI4_ERRM_AWID_STABLE_PROP;
//AWID must remain stable when AWVALID is asserted and AWREADY is LOW
@(posedge aclk) (awvalid == 1 && awready ==0) |-> $stable(awid);
endproperty
AXI4_ERRM_AWID_STABLE : assert property (AXI4_ERRM_AWID_STABLE_PROP);

property AXI4_ERRM_AWID_X_PROP;
//A value of X on AWID is not permitted when AWVALID is HIGH
@(posedge aclk) (awvalid == 1) |-> !($isunknown(awid));
endproperty
AXI4_ERRM_AWID_X : assert property(AXI4_ERRM_AWID_X_PROP);

sequence wvalid_wready_seq;
(wvalid && wready);
endsequence

sequence awvalid_awready_seq;
(awvalid && awready);
endsequence

// property AXI4_ERRM_WDATA_NUM_PROP;
// @(posedge aclk) awvalid_awready_seq |-> wvalid_wready_seq[*1] ##0 wlast==1;
//The number of write data items matches AWLEN for the corresponding address. This is triggered when any of the following occurs:

//Write data arrives and WLAST is set, and the WDATA count is not equal to AWLEN.

//Write data arrives and WLAST is not set, and the WDATA count is equal to AWLEN.

//ADDR arrives, WLAST is already received, and the WDATA count is not equal to AWLEN.
//endproperty
//AXI4_ERRM_WDATA_NUM : assert property(AXI4_ERRM_WDATA_NUM_PROP);

endmodule
