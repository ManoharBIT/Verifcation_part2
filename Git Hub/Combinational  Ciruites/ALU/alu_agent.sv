class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)
    alu_driver   drv;
    alu_monitor  mon;
    uvm_sequencer #(alu_transaction) seqr;
    virtual alu_if vif;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv  = alu_driver::type_id::create("drv", this);
        mon  = alu_monitor::type_id::create("mon", this);
        seqr = uvm_sequencer#(alu_transaction)::type_id::create("seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
        mon.vif = vif;
        drv.vif = vif;
    endfunction
endclass
