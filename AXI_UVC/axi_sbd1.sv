class axi_sbd extends uvm_subscriber#(axi_tx);
bit [`DATA_SIZE-1:0]memory[addr_t];
`uvm_component_utils(axi_sbd)
`NEW_COMP

function void write(axi_tx t);
if (t.wr_rd) begin
foreach (t.dataQ[i]) begin
`uvm_info("SBD",$sformatf("write : addr=%h,data=%h", t.addr, t.dataQ[i]),UVM_FULL);
memory[t.addr] = t.dataQ[i];
t.addr += 2**t.burst_size;
end
end
else begin
foreach (t.dataQ[i]) begin
`uvm_info("SBD",$sformatf("read : addr=%h,data=%h", t.addr, t.dataQ[i]),UVM_FULL);
if (memory[t.addr] == t.dataQ[i]) begin
axi_common::match_count++;

end
else begin
axi_common::mismatch_count++;
`uvm_error("COMPARE",$sformatf("sbd_data=%h,dut_read_byte=%h", memory[t.addr], t.dataQ[i]))
end
t.addr += 2**t.burst_size;
end
end
endfunction

endclass

