//apb_if.sv: Clocking block and Interface example
interface apb_if (input bit pclk, prst);
    logic [11:2] paddr;
    logic [31:0] prdata,pwdata ;
    logic psel,penable,pwrite, pready;

   clocking driver@(posedge pclk);
          default input #1 output #1;  //input and output skew
       //   input prdata,pready;
          output psel,penable,pwrite,paddr,pwdata;
   endclocking

   modport DRV(clocking driver, input prdata, pready, prst); // Use clocking block
   modport MON(input pclk, prst, psel,penable,pwrite,paddr,pwdata, prdata,pready);
     
     
   // assertions for protocol check
   // Assert that write data transfer occurs only when the write strobe (PWRITE) is asserted
     property write; 
       @(posedge pclk) (!prst & psel & penable & pwrite) |-> pready;
     endproperty
     
     assert property (write) $display (" write trans check failed \n");
       
       property p1;
         @(posedge pclk) disable iff (!prst) $rose (pwrite && psel) |-> ($stable(paddr && pwdata)[*2]) ##1 $rose (penable && pready) ##1 $fell (pwrite && psel && penable && pready);
       endproperty
  
       assert property (p1) $display ("Assertion passed",$time);
     

endinterface
