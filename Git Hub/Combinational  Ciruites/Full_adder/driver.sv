//driver class : take the mailbox info and put into DUT through interface

class driver;
  virtual intf vif; //virtual interface : intferface is static, Class is dynamic, so virtual
  //vif pointing to actual interface
  
  mailbox gen2drv;
  
  function new (virtual intf vif, mailbox gen2drv);// constructor
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction
  
  task main();
   
    repeat(4)
       
      begin
        transaction trans;
        
        gen2drv.get(trans);// driver get the transactions from mailbox to driver
        
        vif.a <= trans.a;
        vif.b <= trans.b;
        vif.c <= trans.c;
        #10;
        //trans.sum <= vif.sum;
        //trans.carry <= vif.carry;
        
        trans.display("driver class signals");
      
      end
  endtask
endclass

/*class fa_driver extends uvm_driver #(fa_seq_item);
    `uvm_component_utils(fa_driver)

    virtual fa_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        fa_seq_item req;
        forever begin
            seq_item_port.get_next_item(req);
            vif.a   <= req.a;
            vif.b   <= req.b;
            vif.cin <= req.cin;
            #1; // wait for DUT
            req.sum  = vif.sum;
            req.cout = vif.cout;
            seq_item_port.item_done();
        end
    endtask
endclass
*/ 