class axi_drv extends uvm_driver#(axi_tx);
virtual axi_intf vif;
`uvm_component_utils(axi_drv)
`NEW_COMP

function void build();
if (!uvm_resource_db#(virtual axi_intf)::read_by_name("GLOBAL","AXI_VIF",vif,this))begin
`uvm_error("resource_db","not able to retrieve interface")
end
endfunction
task run();
forever begin
seq_item_port.get_next_item(req);
axi_common::total_byte_count += (req.burst_len+1) * (2**req.burst_size);
drive_tx(req);
req.print();
seq_item_port.item_done();
end
endtask
task drive_tx(axi_tx tx);
if (tx.wr_rd == WRITE) begin
write_addr(tx);
write_data(tx);
write_resp(tx);
end
if (tx.wr_rd == READ) begin
read_addr(tx);
read_data(tx);
end
endtask

task write_addr(axi_tx tx);
`uvm_info("AXI_TX","write_addr",UVM_MEDIUM)
@(vif.drv_cb);
vif.drv_cb.awaddr <= tx.addr;
vif.drv_cb.awlen <= tx.burst_len;
vif.drv_cb.awsize <= tx.burst_size;
vif.drv_cb.awburst<= tx.burst_type;
vif.drv_cb.awid <= tx.id;
vif.drv_cb.awcache <= tx.cache;
vif.drv_cb.awlock <= tx.lock;
vif.drv_cb.awprot <= tx.prot;
vif.drv_cb.awvalid <= 1'b1;
wait (vif.drv_cb.awready == 1'b1);
reset_write_addr_channel();
endtask

task write_data(axi_tx tx);
`uvm_info("AXI_TX","write_data",UVM_MEDIUM)
for (int i =0; i <= tx.burst_len; i++)begin
@(vif.drv_cb);
vif.drv_cb.wdata <= tx.dataQ[i];//.pop_front();
vif.drv_cb.wstrb <= tx.strbQ[i];//.pop_front();
vif.drv_cb.wid <= tx.id;
vif.drv_cb.wlast <= (i ==tx.burst_len) ? 1'b1 : 1'b0;
vif.drv_cb.wvalid <= 1'b1;
wait (vif.drv_cb.wready == 1'b1);
end
reset_write_data_channel();
endtask

task write_resp(axi_tx tx);
`uvm_info("AXI_TX","write_resp",UVM_MEDIUM)
while (vif.drv_cb.bvalid == 1'b0) begin
@(vif.drv_cb);
end
if (vif.drv_cb.bvalid == 1'b1) begin
vif.drv_cb. bready <= 1'b1;
@(vif.drv_cb);
vif.drv_cb. bready <= 1'b0;
end
endtask
task read_addr(axi_tx tx);
`uvm_info("AXI_TX","read_addr",UVM_MEDIUM)
@(vif.drv_cb);
vif.drv_cb.araddr <= tx.addr;
vif.drv_cb.arlen <= tx.burst_len;
vif.drv_cb.arsize <= tx.burst_size;
vif.drv_cb.arburst<= tx.burst_type;
vif.drv_cb.arid <= tx.id;
vif.drv_cb.arcache <= tx.cache;
vif.drv_cb.arlock <= tx.lock;
vif.drv_cb.arprot <= tx.prot;
vif.drv_cb.arvalid <= 1'b1;
wait (vif.drv_cb.arready == 1'b1);
reset_read_addr_channel();
endtask

task read_data(axi_tx tx);
`uvm_info("AXI_TX","read_data",UVM_MEDIUM)
for (int i=0; i<= tx.burst_len; i++) begin
while (vif.drv_cb.rvalid == 1'b0) begin
@(vif.drv_cb);
end
if (vif.drv_cb.rvalid == 1'b1) begin
vif.drv_cb. rready <= 1'b1;
tx.dataQ.push_back(vif.drv_cb.rdata);  
@(vif.drv_cb);
vif.drv_cb. rready <= 1'b0;
end
end
endtask

task reset_read_addr_channel();
@(vif.drv_cb);
vif.drv_cb.araddr <= 0;
vif.drv_cb.arlen <= 0;
vif.drv_cb.arsize <= 0;
vif.drv_cb.arburst<= 0;
vif.drv_cb.arid <= 0;
vif.drv_cb.arcache <=0;
vif.drv_cb.arlock <= 0;
vif.drv_cb.arprot <= 0;
vif.drv_cb.arvalid <= 0;
endtask

task reset_write_addr_channel();
@( vif.drv_cb);
vif.drv_cb.awaddr <= 0;
vif.drv_cb.awlen <= 0;
vif.drv_cb.awsize <= 0;
vif.drv_cb.awburst<= 0;
vif.drv_cb.awid <= 0;
vif.drv_cb.awcache <=0;
vif.drv_cb.awlock <= 0;
vif.drv_cb.awprot <= 0;
vif.drv_cb.awvalid <= 0;
endtask

task reset_write_data_channel();
@( vif.drv_cb);
vif.drv_cb.wdata <= 0;
vif.drv_cb.wstrb <= 0;
vif.drv_cb.wid <= 0;
vif.drv_cb.wlast<= 0;
vif.drv_cb.wvalid <= 0;
endtask
endclass

