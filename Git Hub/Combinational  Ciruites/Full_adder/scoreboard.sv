//scoreboard class

class scoreboard;
  mailbox mon2scb; // mailbox declaration mon to scoreboard
  
  function new (mailbox mon2scb);
    //this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task main();
    
    transaction trans;
    repeat (4)
     
     begin
     mon2scb.get(trans);
     trans.display("scoreboard signals");

        //reference module / golden dut
     if( ( ( trans.a ^ trans.b ^ trans.c) == trans.sum) && ((( trans.a & trans.b ) | ( trans.b & trans.c ) | ( trans.c & trans.a )) == trans.carry)) //reference model logic
      $display("******* PASS *******");
        
      else
      $display("!!!!!!!! FAIL !!!!!!!!!!");     
      $display("//////////////////////////Trasaction Done////////////////////////////////");
      $display("                                                                          ");


      end
  endtask
  
endclass


/*class fa_scoreboard extends uvm_component;
    `uvm_component_utils(fa_scoreboard)

    uvm_analysis_imp #(fa_seq_item, fa_scoreboard) imp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        imp = new("imp", this);
    endfunction

    function void write(fa_seq_item tr);
        bit exp_sum, exp_cout;
        {exp_cout, exp_sum} = tr.a + tr.b + tr.cin;
        if (tr.sum !== exp_sum || tr.cout !== exp_cout)
            `uvm_error("MISMATCH", $sformatf("Got sum=%0d cout=%0d, expected sum=%0d cout=%0d", tr.sum, tr.cout, exp_sum, exp_cout))
        else
            `uvm_info("MATCH", "Transaction matched expected result", UVM_LOW)
    endfunction
endclass
*/