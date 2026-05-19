interface axi_intf(input aclk, arst);
//write
bit [`ADDR_SIZE-1:0] awaddr;
bit [3:0]awid;
bit [3:0]awlen;
bit [1:0]awburst;
bit [2:0]awsize;
bit [2:0]awprot;
bit [1:0]awlock;
bit [1:0]awcache;
bit awvalid;
bit awready;
bit [`DATA_SIZE-1:0]wdata;
bit [`STRB_SIZE-1:0]wstrb;
bit [3:0]wid;
bit wready;
bit wvalid;
bit wlast;
bit [3:0]bid;
bit bready;
bit bvalid;
bit [1:0]bresp;

//read
bit [`ADDR_SIZE-1:0] araddr;
bit [3:0]arid;
bit [3:0]arlen;
bit [1:0]arburst;
bit [2:0]arsize;
bit [2:0]arprot;
bit [1:0]arlock;
bit [1:0]arcache;
bit arvalid;
bit arready;
bit [`DATA_SIZE-1:0]rdata;
bit [3:0]rid;
bit rready;
bit rvalid;
bit rlast;
bit [1:0]rresp;

clocking drv_cb@(posedge aclk);
default input #0 output #0;
//write addr
output awaddr,awid,awlen, awburst,awsize,awprot,awlock,awcache,awvalid;
input awready;
//write data
output wdata,wstrb,wid,wvalid, wlast;
input wready;
//write resp
input bid,bvalid, bresp;
output bready;

//read addr
output araddr,arid,arlen, arburst,arsize,arprot,arlock,arcache,arvalid;
input arready;
//read data
input rdata,rid,rvalid,rlast,rresp;
output rready;

endclocking

clocking resp_cb@(posedge aclk);
default input #0 output #0;
//write addr
input awaddr,awid,awlen, awburst,awsize,awprot,awlock,awcache,awvalid;
output awready;
//write data
input wdata,wstrb,wid,wvalid, wlast;
output wready;
//write resp
output bid,bvalid, bresp;
input bready;

//read addr
input araddr,arid,arlen, arburst,arsize,arprot,arlock,arcache,arvalid;
output arready;
//read data
output rdata,rid,rvalid,rlast,rresp;
input rready;

endclocking
endinterface
