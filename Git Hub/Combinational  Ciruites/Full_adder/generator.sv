//Generator Class : we randomise trans signals and send to driver via mailbox
class generator;
  transaction trans;//
  
  mailbox gen2drv; // mailbox between generator to driver
  
  function new (mailbox gen2drv); //new is a constructor, when you call constructor, it create memory for generator class and allocate memory for variables and initialise with default values
    this.gen2drv = gen2drv;
  endfunction
  
  task main();
    
    repeat (4)
      begin
        trans=new(); //creating object of transaction class
        
        trans.randomize();//it randomise the trans signals declared with rand keyword in transaction class
        
        trans.display("generator class signals");//calling display function to display values
        
        gen2drv.put(trans); // put the transaction data into mailbox
        //#1;
      end
  endtask
  
endclass

/*class fa_sequence extends uvm_sequence #(fa_seq_item);
    `uvm_object_utils(fa_sequence)

    function new(string name = "fa_sequence");
        super.new(name);
    endfunction

    task body();
        fa_seq_item req;
        repeat (10) begin
            req = fa_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize());
            finish_item(req);
        end
    endtask
endclass
*/