class alu_monitor extends uvm_component;
    `uvm_component_utils(alu_monitor)
    virtual alu_if vif;
    uvm_analysis_port #(alu_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        alu_transaction tr;
        forever begin
            tr = alu_transaction::type_id::create("tr");
            @(posedge vif.clk);
            tr.a = vif.a;
            tr.b = vif.b;
            tr.alu_op = vif.alu_op;
            ap.write(tr);
        end
    endtask
endclass
