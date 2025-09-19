//top_tb.sv : apb uart testbench
`timescale 1ns/1ps
 `define timeout 1000000

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "apb_if.sv"
  
// include and import testbench
`include "apb_pkg.sv"
import apb_pkg::*;

// sequences
`include "apb_sequences.sv"

// Tests
`include "apb_mem_tests.sv"

// memory testbench module
module tb_top;
    reg clk, resetn;
  // apb interface
   apb_if apb_if_r(clk, resetn); // physical interface 


// APB UART (DUT) instantiation 
   apb_mem apb_mem_inst(
          .PCLK(clk), 
          .PRESETn (resetn), 
          .PSEL(apb_if_r.psel),     
          .PADDR(apb_if_r.paddr),   
          .PENABLE(apb_if_r.penable),  
          .PWRITE(apb_if_r.pwrite),   
          .PWDATA(apb_if_r.pwdata),   
          .PRDATA(apb_if_r.prdata),   
          .PREADY(apb_if_r.pready)   
          //.PSLVERR() 
   ); 

// clock generation 
 initial begin
   clk = 0;
   forever
     #5 clk = ~clk;
 end
  //reset generation 
 initial begin
   resetn = 0;
   #12
   resetn = 1;
 end
// run test
initial begin 
     //Setting physical Interface APB_if to config.
     uvm_config_db#(virtual apb_if)::set(null,"*","vif0", apb_if_r);
        
     // running tests
     run_test("apb_write_read_test"); // test case is passed from command line
     #100;   

  end
  initial begin 
     global_stop_request(); 
  end
 //dump waves
 initial begin
   $dumpfile("apb_mem.vcd");
   $dumpvars;
 end
endmodule
