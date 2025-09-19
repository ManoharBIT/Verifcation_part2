// File: full_adder_tb.sv
module full_adder_tb;

    parameter WIDTH = 4;

    logic [WIDTH-1:0] a, b;
    logic             cin;
    logic [WIDTH-1:0] sum;
    logic             cout;

    full_adder #(.WIDTH(WIDTH)) dut (
        .a(a), .b(b), .cin(cin),
        .sum(sum), .cout(cout)
    );
full_adder_sva #(.WIDTH(WIDTH)) sva_inst (
    .clk(clk),
    .a(a), .b(b), .cin(cin),
    .sum(sum), .cout(cout)
);

    initial begin
        $display("---- SystemVerilog Full Adder Testbench ----");
        for (int i = 0; i < (1 << (2 * WIDTH)); i++) begin
            {a, b} = i;
            cin = i % 2;
            #5;
            $display("a=%b, b=%b, cin=%b => sum=%b, cout=%b", a, b, cin, sum, cout);
        end
        $finish;
    end
endmodule
