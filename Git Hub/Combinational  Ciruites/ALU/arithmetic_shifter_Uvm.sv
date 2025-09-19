`timescale 1ns/1ps
// ===========================================
// DUT - Arithmetic Shifter
// ===========================================
module arithmetic_shifter (
    input  logic [7:0] data_in,
    input  logic [2:0] shift_amt,
    input  logic       dir,
    output logic [7:0] data_out
);
    always_comb begin
        if (dir == 0)
            data_out = data_in <<< shift_amt;
        else
            data_out = $signed(data_in) >>> shift_amt;
    end
endmodule

// ===========================================
// Interface
// ===========================================
interface shifter_if(input logic clk);
    logic [7:0] data_in;
    logic [2:0] shift_amt;
    logic       dir;
    logic [7:0] data_out;
endinterface

// ===========================================
// Transaction
// ===========================================
class shifter_txn extends uvm_sequence_item;
    rand logic [7:0] data_in;
    rand logic [2:0] shift_amt;
    rand logic       dir;
         logic [7:0] expected_out;

    `uvm_object_utils(shifter_txn)

    function new(string name = "shifter_txn");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("data_in", data_in, 8);
        printer.print_field("shift_amt", shift_amt, 3);
        printer.print_field("dir", dir, 1);
        printer.print_field("expected_out", expected_out, 8);
    endfunction

    function void compute_expected();
        if (dir == 0)
            expected_out = data_in <<< shift_amt;
        else
            expected_out = $signed(data_in) >>> shift_amt;
    endfunction
endclass

// ===========================================
// Driver
// ===========================================
class shifter_driver extends uvm_driver #(shifter_txn);
    virtual shifter_if vif;

    `uvm_component_utils(shifter_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual shifter_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "vif not found")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            shifter_txn tx;
            seq_item_port.get_next_item(tx);
            vif.data_in   <= tx.data_in;
            vif.shift_amt <= tx.shift_amt;
            vif.dir       <= tx.dir;
            #5;
            seq_item_port.item_done();
        end
    endtask
endclass

// ===========================================
// Monitor
// ===========================================
class shifter_monitor extends uvm_monitor;
    virtual shifter_if vif;
    uvm_analysis_port #(shifter_txn) ap;

    `uvm_component_utils(shifter_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        if (!uvm_config_db#(virtual shifter_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "vif not found")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            shifter_txn tx = shifter_txn::type_id::create("tx");
            #5;
            tx.data_in   = vif.data_in;
            tx.shift_amt = vif.shift_amt;
            tx.dir       = vif.dir;
            tx.compute_expected();
            tx.expected_out = tx.expected_out;
            #1;
            if (vif.data_out !== tx.expected_out)
                `uvm_error("MON", $sformatf("Mismatch: Got %h, Expected %h", vif.data_out, tx.expected_out))
            else
                `uvm_info("MON", $sformatf("PASS: data_in=%h dir=%b shift=%0d out=%h", tx.data_in, tx.dir, tx.shift_amt, vif.data_out), UVM_LOW)
            ap.write(tx);
        end
    endtask
endclass

// ===========================================
// Agent
// ===========================================
class shifter_agent extends uvm_agent;
    shifter_driver  drv;
    shifter_monitor mon;

    `uvm_component_utils(shifter_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        drv = shifter_driver::type_id::create("drv", this);
        mon = shifter_monitor::type_id::create("mon", this);
    endfunction
endclass

// ===========================================
// Scoreboard
// ===========================================
class shifter_scoreboard extends uvm_component;
    uvm_analysis_imp #(shifter_txn, shifter_scoreboard) analysis_export;

    `uvm_component_utils(shifter_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void write(shifter_txn tx);
        if (tx.expected_out !== tx.expected_out)
            `uvm_error("SCORE", $sformatf("ERROR: Got = %h Expected = %h", tx.expected_out, tx.expected_out))
        else
            `uvm_info("SCORE", $sformatf("CORRECT: %h", tx.expected_out), UVM_LOW)
    endfunction
endclass

// ===========================================
// Sequence
// ===========================================
class shifter_sequence extends uvm_sequence #(shifter_txn);
    `uvm_object_utils(shifter_sequence)

    function new(string name = "shifter_sequence");
        super.new(name);
    endfunction

    task body;
        repeat (10) begin
            shifter_txn tx = shifter_txn::type_id::create("tx");
            assert(tx.randomize());
            tx.compute_expected();
            start_item(tx);
            finish_item(tx);
        end
    endtask
endclass

// ===========================================
// Environment
// ===========================================
class shifter_env extends uvm_env;
    shifter_agent agt;
    shifter_scoreboard sb;

    `uvm_component_utils(shifter_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        agt = shifter_agent::type_id::create("agt", this);
        sb  = shifter_scoreboard::type_id::create("sb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agt.mon.ap.connect(sb.analysis_export);
    endfunction
endclass

// ===========================================
// Test
// ===========================================
class shifter_test extends uvm_test;
    `uvm_component_utils(shifter_test)

    shifter_env env;
    shifter_sequence seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env = shifter_env::type_id::create("env", this);
        seq = shifter_sequence::type_id::create("seq");
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq.start(env.agt.drv.seq_item_port);
        phase.drop_objection(this);
    endtask
endclass

// ===========================================
// Top Module for Simulation
// ===========================================
module tb_top;
    logic clk = 0;
    always #5 clk = ~clk;

    shifter_if sif(clk);
    arithmetic_shifter dut (
        .data_in(sif.data_in),
        .shift_amt(sif.shift_amt),
        .dir(sif.dir),
        .data_out(sif.data_out)
    );

    initial begin
        uvm_config_db#(virtual shifter_if)::set(null, "*", "vif", sif);
        run_test("shifter_test");
    end
endmodule
