
`include "interface.sv"
`include "test.sv"

module testbench;
  
  intf intff(); // interface
  test tst (intff); // test
  
  full_adder FA(  // DUT
    .a(intff.a), 
    .b(intff.b),
    .c(intff.c),
    .sum(intff.sum), 
    .carry(intff.carry)
  );
  

  initial begin
    $dumpfile("dump.vcd"); // to get waveform
    $dumpvars;
  end
  
  initial
#100 $finish;
endmodule