module top;
    logic clk;
    alu_if alu_if1(clk);

    alu dut(
        .a(alu_if1.a),
        .b(alu_if1.b),
        .alu_op(alu_if1.alu_op),
        .result(alu_if1.result)
    );

    initial clk=0; always #5 clk=~clk;

    initial begin
        run_test("alu_test");
    end
endmodule
