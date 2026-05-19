`define ADDR_SIZE 16
`define DATA_SIZE 32
`define STRB_SIZE `DATA_SIZE/8
`define BURST_SIZE $clog2(`STRB_SIZE)
`define WRITE 1'b1
`define READ 1'b0
`define TX_COUNT 50
typedef bit [`ADDR_SIZE-1:0] addr_t;

`define NEW_COMP \
function new(string name,uvm_component parent); \
super.new(name, parent); \
endfunction

`define NEW_OBJ \
function new(string name=""); \
super.new(name); \
endfunction

class axi_common;
static int match_count;
static int mismatch_count;
static int total_byte_count;
endclass

