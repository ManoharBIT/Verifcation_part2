// File: half_adder_sva.sv
module half_adder_sva #(
    parameter WIDTH = 1
)(
    input  logic clk,
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [WIDTH-1:0] sum,
    input  logic [WIDTH-1:0] carry
);

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin : gen_assert
            // Property: Sum is XOR of a and b
            property p_sum_correct;
                @(posedge clk) sum[i] == a[i] ^ b[i];
            endproperty
            assert property (p_sum_correct)
                else $error("Assertion failed: sum[%0d] != a[%0d] ^ b[%0d]", i, i, i);

            // Property: Carry is AND of a and b
            property p_carry_correct;
                @(posedge clk) carry[i] == a[i] & b[i];
            endproperty
            assert property (p_carry_correct)
                else $error("Assertion failed: carry[%0d] != a[%0d] & b[%0d]", i, i, i);
        end
    endgenerate

endmodule
