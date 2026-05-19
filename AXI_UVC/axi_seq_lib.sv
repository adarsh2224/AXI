class axi_base_seq extends uvm_sequence#(axi_tx);
axi_tx tx,tx_t;
axi_tx txQ[$];
uvm_phase phase;
int count;
  `uvm_object_utils(axi_base_seq)
`NEW_OBJ
  
  task pre_body();
uvm_resource_db#(int)::read_by_name("GLOBAL","COUNT",count,this);
  phase = get_starting_phase();
  if (phase !=null) begin
    phase.raise_objection(this);
    phase.phase_done.set_drain_time(this,100);
  end
  endtask
  
  task post_body();
    if (phase !=null)
      phase.drop_objection(this);
  endtask
endclass
  
class axi_wr_rd_seq extends axi_base_seq;
`uvm_object_utils(axi_wr_rd_seq)
`NEW_OBJ
  
task body();
        `uvm_do_with(req, {req.wr_rd==1'b1;})
		 tx_t = new req;
		`uvm_do_with(req, {req.wr_rd==1'b0; 
		                   req.addr==tx_t.addr;
		                   req.burst_len==tx_t.burst_len;
		                   req.burst_type==tx_t.burst_type;
		                   req.burst_size==tx_t.burst_size;
						   })
endtask
endclass


class axi_n_wr_n_rd_seq extends axi_base_seq;
`uvm_object_utils(axi_n_wr_n_rd_seq)
`NEW_OBJ
  
task body();
repeat(count)begin
        `uvm_do_with(req, {req.wr_rd==1'b1;})
		tx_t = new req;
		txQ.push_back(tx_t);
		end
repeat(count) begin
		 tx_t = txQ.pop_front();
		`uvm_do_with(req, {req.wr_rd==1'b0; 
		                   req.addr==tx_t.addr;
		                   req.burst_len==tx_t.burst_len;
		                   req.burst_type==tx_t.burst_type;
		                   req.burst_size==tx_t.burst_size;
						   })
	end
endtask
endclass


