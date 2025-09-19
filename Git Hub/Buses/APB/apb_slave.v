module apb_slave #(SLAVE_MEM_SIZE=64)(
    input pclk,
    input presetn,
    input psel,
    input penable,
    input pwrite,
    input [7:0] paddr,
    input [7:0] pwdata,
    output [7:0] prdata,
    output reg pready
);

    reg [7:0] mem[63:0];
    reg [7:0] addr;

    // Read logic (combinational)
    assign prdata = mem[addr];

    // Sequential block for read/write operations
    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            pready <= 0;
            addr <= 0;
        end
        else begin
            // Read operation
            if (psel && penable && !pwrite) begin
                pready <= 1;
                addr <= paddr;
            end
            // Write operation
            else if (psel && penable && pwrite) begin
                pready <= 1;
                mem[paddr] <= pwdata;
                addr <= paddr; // update addr for read-back
            end
            else begin
                pready <= 0;
            end
        end
    end

endmodule
