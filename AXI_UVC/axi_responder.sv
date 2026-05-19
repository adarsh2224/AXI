class axi_responder extends uvm_component;
virtual axi_intf vif;
//memory
byte mem[int];

bit [`ADDR_SIZE-1:0]araddr_t;
bit [3:0]arlen_t ;
bit [2:0]arsize_t;
bit [1:0]arburst_t; 
bit [3:0]arid_t;

bit [`ADDR_SIZE-1:0]awaddr_t;
bit [3:0]awlen_t;
bit [2:0]awsize_t;
bit [1:0]awburst_t;
bit [3:0]awid_t ;
int beat_count;

`uvm_component_utils(axi_responder)
`NEW_COMP

function void build();
if (!uvm_resource_db#(virtual axi_intf)::read_by_name("GLOBAL","AXI_VIF",vif,this))begin
`uvm_error("resource_db","not able to retrieve interface")
end
endfunction

task run();
forever begin
@(posedge vif.aclk);
vif.awready = 1'b0;
vif.wready = 1'b0;
vif.arready = 1'b0;
//write addr channel handshake
if(vif.awvalid == 1'b1)begin
vif.awready = 1'b1;
awaddr_t = vif.awaddr;
awlen_t = vif.awlen;
awsize_t = vif.awsize;
awburst_t = vif.awburst;
awid_t = vif.awid;
beat_count = 0;
end
//write data channel handshake  
if(vif.wvalid == 1'b1)begin
vif.wready = 1'b1;
if (beat_count>0) begin
store_wdata_to_mem(vif.wdata, vif.wstrb);
end
beat_count++;
if (vif.wlast == 1) begin
fork
drive_write_resp(vif.wid);
join_none
end
end
//read addr channel handshake
if(vif.arvalid == 1'b1)begin
vif.arready = 1'b1;
araddr_t = vif.araddr;
arlen_t = vif.arlen;
arsize_t = vif.arsize;
arburst_t = vif.arburst;
arid_t = vif.arid;
drive_read_data(vif.arid);
end
end
endtask

function store_wdata_to_mem(bit [`DATA_SIZE-1:0]data,
                            bit [`STRB_SIZE-1:0] strb);
bit [`DATA_SIZE-1:0] wdata;
bit [`STRB_SIZE-1:0] wstrb;
wdata = data;
wstrb = strb;
for (int j=0; j< `DATA_SIZE/8; j++) begin
if (wstrb[j] == 1) begin
mem[awaddr_t] = wdata[7:0];
awaddr_t++;
end
wdata >>= 8;
end
//awaddr_t = awaddr_t + 2**awsize_t;
endfunction

task drive_write_resp(bit[3:0]id);
@(posedge vif.aclk);
vif.bid=id;
vif.bresp= OKAY;
vif.bvalid = 1'b1;
wait (vif.bready == 1'b1);
reset_write_resp();
endtask

task reset_write_resp();
@(posedge vif.aclk);
vif.bid=0;
vif.bresp= OKAY;
vif.bvalid = 0;

endtask

task drive_read_data(bit[3:0]id);
for (int i=0; i<= arlen_t; i++) begin
@(posedge vif.aclk);
vif.rid=id;
vif.rlast = (i==arlen_t) ? 1'b1 : 1'b0;
for (int j = `DATA_SIZE/8-1; j >= 0; j--) begin
vif.rdata[7:0] = mem[araddr_t+j];
if (j !=0) vif.rdata <<= 8;
end
//vif.rdata={
//mem[araddr_t+3],
//mem[araddr_t+2],
//mem[araddr_t+1],
//mem[araddr_t+0]
//};
vif.rresp= OKAY;
vif.rvalid = 1'b1;
wait (vif.rready == 1'b1);
araddr_t = araddr_t + 2**arsize_t;
end
reset_read_data();
endtask

task reset_read_data();
@(posedge vif.aclk);
vif.rid=0;
vif.rdata=0;
vif.rresp= OKAY;
vif.rvalid = 0;
vif.rlast = 0;

endtask
endclass
