class fa_agent extends uvm_agent;
    `uvm_component_utils(fa_agent)

    fa_driver drv;
    fa_monitor mon;
    uvm_sequencer #(fa_seq_item) seqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = uvm_sequencer#(fa_seq_item)::type_id::create("seqr", this);
        drv  = fa_driver::type_id::create("drv", this);
        mon  = fa_monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass
