module apb_top #(
    parameter ADDR_WIDTH = 9,       // Width of APB address
    parameter SLAVE_MEM_SIZE = 64,  // Memory size per slave
    parameter NUM_SLAVES = 64       // Number of slaves
)(
    input pclk,
    input presetn,
    input transfer,
    input read,
    input write,
    input [ADDR_WIDTH-1:0] apb_write_padder,
    input [ADDR_WIDTH-1:0] apb_write_data,
    input [ADDR_WIDTH-1:0] apb_read_paddr,

    output pslverr,
    output [7:0] apb_read_data_out
);

    // Calculate bits needed to select slaves
    localparam SLAVE_SEL_BITS = $clog2(NUM_SLAVES);

    // Wires
    wire [ADDR_WIDTH-1:0] paddr;
    wire [NUM_SLAVES-1:0] psel;
    wire penable, pwrite;
    wire [8:0] pwdata;                 // master pwdata width
    wire [7:0] prdata [0:NUM_SLAVES-1];
    wire pready [0:NUM_SLAVES-1];

    // Decode top bits of address to select active slave
    reg [NUM_SLAVES-1:0] psel_reg;
    integer j;
    always @(*) begin
        psel_reg = 0;
        if (transfer)
            psel_reg[paddr[ADDR_WIDTH-1:ADDR_WIDTH-SLAVE_SEL_BITS]] = 1'b1;
    end
    assign psel = psel_reg;

    // Multiplex prdata and pready based on selected slave
    wire [7:0] prdata_mux;
    wire pready_mux;
    assign prdata_mux = prdata[paddr[ADDR_WIDTH-1:ADDR_WIDTH-SLAVE_SEL_BITS]];
    assign pready_mux = pready[paddr[ADDR_WIDTH-1:ADDR_WIDTH-SLAVE_SEL_BITS]];

    // Master instance
    master dut_mas (
        .apb_write_padder(apb_write_padder[8:0]),
        .read_padder(apb_read_paddr[8:0]),
        .apb_write_data(apb_write_data[8:0]),
        .prdata(prdata_mux),
        .presetn(presetn),
        .pclk(pclk),
        .read(read),
        .write(write),
        .transfer(transfer),
        .pready(pready_mux),
        .psel1(psel[0]),  // master still has psel1 and psel2 for simplicity
        .psel2(psel[1]),
        .penable(penable),
        .paddr(paddr),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .apb_read_data_out(apb_read_data_out),
        .pslverr(pslverr)
    );

    // Generate block for multiple slaves
    genvar i;
    generate
        for (i = 0; i < NUM_SLAVES; i = i + 1) begin : slave_gen
            apb_slave #(
                .SLAVE_MEM_SIZE(SLAVE_MEM_SIZE)
            ) dut_slave (
                .pclk(pclk),
                .presetn(presetn),
                .psel(psel[i]),
                .penable(penable),
                .pwrite(pwrite),
                .paddr(paddr[ADDR_WIDTH-SLAVE_SEL_BITS-1:0]), // lower bits for memory
                .pwdata(pwdata),
                .prdata(prdata[i]),
                .pready(pready[i])
            );
        end
    endgenerate

endmodule
