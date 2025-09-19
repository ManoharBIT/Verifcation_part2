// File: half_adder.v
`timescale 1ns / 1ps

module half_adder #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] sum,
    output [WIDTH-1:0] carry
);

    assign sum   = a ^ b;
    assign carry = a & b;

endmodule
