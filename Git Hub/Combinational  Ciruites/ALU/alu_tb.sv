module alu_tb;
    logic [3:0] a, b;
    logic [2:0] sel;
    logic [3:0] result;
    logic carry, zero;

    alu dut (.a(a), .b(b), .sel(sel), .result(result), .carry(carry), .zero(zero));

    initial begin
        a = 4'hA; b = 4'h3;

        foreach (sel[i]) begin
            sel = i;
            #10;
            $display("a=%h, b=%h, sel=%b => result=%h, carry=%b, zero=%b", a, b, sel, result, carry, zero);
        end
        $finish;
    end
endmodule
