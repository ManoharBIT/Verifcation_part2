class alu_transaction extends uvm_sequence_item;
`uvm_object_utils(alu_transaction)
    rand bit [7:0] a;
    rand bit [7:0] b;
    rand bit [2:0] alu_op;
     bit [7:0] exp_result;

    

    function new(string name="alu_transaction");
        super.new(name);
		`uvm_info("sequence item Class", "constructor", UVM_MEDIUM)
		endfunction
    

    function string convert2string();
        return $sformatf("a=%0d b=%0d op=%0d exp=%0d", a,b,alu_op,exp_result);
    endfunction
endclass
