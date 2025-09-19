`timescale 1ns/1ps

module half_adder_tb;
    parameter WIDTH = 1;

    logic [WIDTH-1:0] a, b;
    logic [WIDTH-1:0] sum, carry;

    half_adder #(.WIDTH(WIDTH)) dut (
        .a(a), .b(b), .sum(sum), .carry(carry)
    );

    initial begin
        $display("Start Half Adder TB");
        repeat (4) begin
            {a, b} = $random;
            #5;
            $display("a=%b b=%b sum=%b carry=%b", a, b, sum, carry);
        end
        $finish;
    end
endmodule
