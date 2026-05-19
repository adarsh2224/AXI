
typedef enum bit {
READ,
WRITE
}wr_rd_t;

typedef enum bit [1:0] {
FIXED,
INCR,
WRAP,
RSVD_BURST
} burst_type_t;

typedef enum bit [1:0] {
NORMAL,
EXCEL,
LOCK,
RSVD_LOCK
} lock_t;

typedef enum bit [1:0] {
OKAY,
EXOKAY,
SLVERR,
DECERR
} resp_t;

class axi_tx extends uvm_sequence_item;
rand wr_rd_t wr_rd;
rand bit [`ADDR_SIZE-1:0] addr;
rand bit [3:0] id;
rand bit [3:0] burst_len;
rand bit [2:0] burst_size;
rand burst_type_t burst_type;
rand bit [1:0] cache;
rand bit [2:0] prot;
rand  lock_t lock;
rand bit [`DATA_SIZE-1:0] dataQ[$];
rand bit [`STRB_SIZE-1:0] strbQ[$];
rand resp_t respQ[$];

int tx_size;
rand bit [31:0] wrap_lower_addr;
rand bit [31:0] wrap_upper_addr;

`uvm_object_utils_begin(axi_tx)
`uvm_field_enum(wr_rd_t,wr_rd, UVM_ALL_ON)
`uvm_field_int(addr, UVM_ALL_ON)
`uvm_field_int(id, UVM_ALL_ON)
`uvm_field_int(burst_len, UVM_ALL_ON)
`uvm_field_int(burst_size, UVM_ALL_ON)
`uvm_field_enum(burst_type_t,burst_type, UVM_ALL_ON)
`uvm_field_int(cache, UVM_ALL_ON)
`uvm_field_int(prot, UVM_ALL_ON)
`uvm_field_enum(lock_t,lock, UVM_ALL_ON)
`uvm_field_queue_int(dataQ, UVM_ALL_ON)
`uvm_field_queue_int(strbQ, UVM_ALL_ON)
`uvm_field_queue_enum(resp_t,respQ, UVM_ALL_ON)

`uvm_object_utils_end
`NEW_OBJ

constraint rsvd_value_c {
burst_type != RSVD_BURST;
lock !=RSVD_LOCK;
}

constraint burst_len_c {
wr_rd == WRITE -> (dataQ.size() == burst_len + 1 && strbQ.size() == burst_len + 1);
wr_rd == READ -> dataQ.size() == 0 && strbQ.size() == 0;
}

constraint soft_c {
soft burst_type == INCR;
soft burst_size ==`BURST_SIZE;
soft lock == NORMAL;
soft addr%2**burst_size == 0;
foreach (strbQ[i]) {
soft strbQ[i] =={`STRB_SIZE{1'b1}};
}
}

function void post_randomize();
if(burst_type==WRAP) begin
tx_size = (burst_len+1)*(2**burst_size);
wrap_lower_addr = addr - (addr%tx_size);
wrap_upper_addr= wrap_lower_addr + tx_size - 1;
end
endfunction
endclass
