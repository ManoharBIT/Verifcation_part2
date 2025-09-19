interface alu_if #(parameter WIDTH=8)(input logic clk);
    logic [WIDTH-1:0] a;
    logic [WIDTH-1:0] b;
    logic [2:0]       alu_op;
    logic [WIDTH-1:0] result;
endinterface
