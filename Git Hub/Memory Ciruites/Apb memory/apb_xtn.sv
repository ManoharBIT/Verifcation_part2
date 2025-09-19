`include "uvm_macros.svh"
import uvm_pkg::*;
//Sequence item for APB Transaction
typedef enum {READ, WRITE} trans;

class apb_xtn extends uvm_sequence_item;
  `uvm_object_utils(apb_xtn)
  rand bit [9:0] addr;
  rand trans trans_type;
  rand bit [31:0] wdata;
  bit [31:0] rdata;
  extern function new(string name="apb_xtn");
  extern function void do_print(uvm_printer printer);
endclass:apb_xtn

//constructor
function apb_xtn :: new(string name="apb_xtn");
  super.new(name);
endfunction:new

//printer
function void apb_xtn :: do_print(uvm_printer printer);
  super.do_print(printer);
  printer.print_field("addr",this.addr,10,UVM_HEX);
  printer.print_field("trans_type",this.trans_type,1,UVM_HEX);
  printer.print_field("wdata",this.wdata,8,UVM_HEX);
  printer.print_field("rdata",this.rdata,8,UVM_HEX);
endfunction:do_print
