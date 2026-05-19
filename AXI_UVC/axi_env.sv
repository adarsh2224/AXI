class axi_env extends uvm_env;
axi_master_agent m_agent;
axi_slave_agent s_agent;
axi_sbd sbd;
axi_mon mon;
axi_cov cov;
`uvm_component_utils(axi_env);
`NEW_COMP

function void build();
m_agent=axi_master_agent::type_id::create("m_agent",this);
s_agent=axi_slave_agent::type_id::create("s_agent",this);
sbd = axi_sbd::type_id::create("sbd",this);
mon = axi_mon::type_id::create("mon",this);
cov= axi_cov::type_id::create("cov",this);
endfunction

function void connect();
mon.ap_port.connect(sbd.analysis_export);
mon.ap_port.connect(cov.analysis_export);
endfunction
endclass

