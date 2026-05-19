class axi_slave_agent extends uvm_agent;
axi_responder responder;
`uvm_component_utils(axi_slave_agent)
`NEW_COMP
function void build();
responder = axi_responder::type_id::create("responder",this);
endfunction
endclass
