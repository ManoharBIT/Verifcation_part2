class alu_sequence extends uvm_sequence #(alu_transaction);
    `uvm_object_utils(alu_sequence)

    function new(string name="alu_sequence");
        super.new(name);
    endfunction

    task body();
        alu_transaction tr;
        repeat(10) begin
            tr = alu_transaction::type_id::create("tr");
            assert(tr.randomize());
            case(tr.alu_op)
                3'b000: tr.exp_result = tr.a + tr.b;
                3'b001: tr.exp_result = tr.a - tr.b;
                3'b010: tr.exp_result = tr.a & tr.b;
                3'b011: tr.exp_result = tr.a | tr.b;
                3'b100: tr.exp_result = tr.a ^ tr.b;
                3'b101: tr.exp_result = ~(tr.a);
                default: tr.exp_result = 0;
            endcase
            start_item(tr);
            finish_item(tr);
        end
    endtask
endclass
