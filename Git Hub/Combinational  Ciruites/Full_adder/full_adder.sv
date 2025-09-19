// Half Adder Module
module half_adder (
    input  a,
    input  b,
    output sum,
    output cout
);
    assign sum   = a ^ b;   // XOR for sum
    assign carry = a & b;   // AND for carry
endmodule

// Full Adder using two Half Adders
module full_adder (
    input  a,
    input  b,
    input  c,
    output sum,
    output carry
);
    wire sum1, cout1, cout2;

    // First Half Adder
    half_adder HA1 (
        .a(a),
        .b(b),
        .sum(sum1),
        .carry(cout1)
    );

    // Second Half Adder
    half_adder HA2 (
        .a(sum1),
        .b(cin),
        .sum(sum),
        .carry(cout2)
    );

    // Final Carry Out
    assign carry = cout1 | cout2;

endmodule
