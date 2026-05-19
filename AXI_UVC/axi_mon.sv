class axi_mon extends uvm_monitor;
uvm_analysis_port#(axi_tx) ap_port;
virtual axi_intf vif;
axi_tx tx;
`uvm_component_utils(axi_mon)
`NEW_COMP
function void build();
ap_port=new("ap_port",this);
if (!uvm_resource_db#(virtual axi_intf)::read_by_name("GLOBAL","AXI_VIF",vif,this))begin
end
endfunction

task run();
forever begin
@(posedge vif.aclk);
if(vif.awvalid && vif.awready) begin
//write addr channel information is valid => collect that info
tx = axi_tx::type_id::create("tx");
tx.wr_rd = WRITE;
tx.addr = vif.awaddr;
tx.id = vif.awid;
tx.burst_len = vif.awlen;
tx.burst_size = vif.awsize;
tx.burst_type = burst_type_t'(vif.awburst);
tx.cache= vif.awcache;
tx.prot= vif.awprot;
tx.lock=lock_t'( vif.awlock);

end
if(vif.wvalid && vif.wready) begin
tx.dataQ.push_back(vif.wdata);
tx.strbQ.push_back(vif.wstrb);
end
if(vif.bvalid && vif.bready) begin
tx.respQ.push_back(vif.bresp);
ap_port.write(tx);
end
if(vif.arvalid && vif.arready) begin

//read addr channel information is valid => collect that info
tx = axi_tx::type_id::create("tx");
tx.wr_rd = READ;
tx.addr = vif.araddr;
tx.id = vif.arid;
tx.burst_len = vif.arlen;
tx.burst_size = vif.arsize;
tx.burst_type = burst_type_t'(vif.arburst);
tx.cache= vif.arcache;
tx.prot= vif.arprot;
tx.lock=lock_t'( vif.arlock);
end
if(vif.rvalid && vif.rready) begin
tx.dataQ.push_back(vif.rdata);
tx.respQ.push_back(vif.rresp);
if (vif.rlast)ap_port.write(tx);

end
end
endtask
endclass


