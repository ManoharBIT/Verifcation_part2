module half_adder #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] a, b,
    output logic [WIDTH-1:0] sum,
    output logic [WIDTH-1:0] carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule
