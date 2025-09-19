//environment class
//include all lower classes
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard scb;
  
  mailbox gen2drv;
  mailbox mon2scb;
  
  virtual intf vif;
  
  function new (virtual intf vif);
    this.vif = vif;
    
    gen2drv = new();
    mon2scb = new();
    gen = new(gen2drv);
    drv = new(vif, gen2drv);
    mon = new(vif, mon2scb);
    scb = new(mon2scb);

  endfunction
  
  
  task test_run();
    fork //start all together
      gen.main();
      drv.main();
      mon.main();
      scb.main();
    join 
  endtask
  
endclass/*class fa_env extends uvm_env;
    `uvm_component_utils(fa_env)

    fa_agent agt;
    fa_scoreboard scb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = fa_agent::type_id::create("agt", this);
        scb = fa_scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(scb.imp);
    endfunction
endclass
*/