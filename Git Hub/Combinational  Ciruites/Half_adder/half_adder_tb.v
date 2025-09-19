// File: half_adder_tb.v
`timescale 1ns / 1ps

module half_adder_tb;

    parameter WIDTH = 4;

    reg  [WIDTH-1:0] a, b;
    wire [WIDTH-1:0] sum, carry;

    // DUT instantiation
    half_adder #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    integer i;

    initial begin
        $display("------ Half Adder Testbench Start ------");
        for (i = 0; i < (1 << (2 * WIDTH)); i = i + 1) begin
            {a, b} = i;
            #5;
            $display("a=%b, b=%b --> sum=%b, carry=%b", a, b, sum, carry);
        end
        $display("------ Half Adder Testbench End   ------");
        $finish;
    end

endmodule
