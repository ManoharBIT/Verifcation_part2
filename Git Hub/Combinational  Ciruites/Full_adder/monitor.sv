//monitor class

class monitor;
  
  virtual intf vif;
  mailbox mon2scb;
  
  function new(virtual intf vif, mailbox mon2scb);
    this.vif = vif;
    this.mon2scb=mon2scb;
  endfunction
  
  task main();
    repeat(4)
    #1
    begin
    transaction trans;
    trans = new(); // constructor, creating object of class
    
    //sampling
    trans.a = vif.a;
    trans.b = vif.b;
    trans.c = vif.c;
    trans.sum = vif.sum;
    trans.carry = vif.carry;
    
    mon2scb.put(trans);
      
    trans.display("monitor class signals");
      
    end
  endtask
  
endclass/*class fa_monitor extends uvm_component;
    `uvm_component_utils(fa_monitor)

    virtual fa_if vif;
    uvm_analysis_port #(fa_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        fa_seq_item tr;
        forever begin
            @(posedge vif.clk);
            tr = fa_seq_item::type_id::create("tr");
            tr.a   = vif.a;
            tr.b   = vif.b;
            tr.cin = vif.cin;
            tr.sum = vif.sum;
            tr.cout= vif.cout;
            ap.write(tr);
        end
    endtask
endclass
*/
    