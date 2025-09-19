class alu_scoreboard extends uvm_component;
    `uvm_component_utils(alu_scoreboard)
    uvm_analysis_imp #(alu_transaction, alu_scoreboard) imp;
    virtual alu_if vif;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        imp = new("imp", this);
    endfunction

    function void write(alu_transaction tr);
        bit [7:0] ref;
        case(tr.alu_op)
            3'b000: ref = tr.a + tr.b;
            3'b001: ref = tr.a - tr.b;
            3'b010: ref = tr.a & tr.b;
            3'b011: ref = tr.a | tr.b;
            3'b100: ref = tr.a ^ tr.b;
            3'b101: ref = ~(tr.a);
            default: ref = 0;
        endcase

        if(vif.result !== ref)
            `uvm_error("ALU_SCB", $sformatf("Mismatch: got=%0d exp=%0d", vif.result, ref))
        else
            `uvm_info("ALU_SCB", $sformatf("PASS: a=%0d b=%0d op=%0d result=%0d",
                        tr.a, tr.b, tr.alu_op, vif.result), UVM_LOW)
    endfunction
endclass
