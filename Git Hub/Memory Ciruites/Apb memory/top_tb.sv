`timescale 1ns/1ps

module tb_apb_mem;

  // Parameters
  parameter ADDR_WIDTH = 10;
  parameter DATA_WIDTH = 32;
  parameter RDY_COUNT  = 1;

  // Signals
  reg                 PCLK;
  reg                 PRESETn;
  reg                 PSEL;
  reg [ADDR_WIDTH-1:0] PADDR;
  reg                 PENABLE;
  reg                 PWRITE;
  reg [DATA_WIDTH-1:0] PWDATA;
  wire [DATA_WIDTH-1:0] PRDATA;
  wire                PREADY;

  // Instantiate DUT
  apb_mem #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .RDY_COUNT(RDY_COUNT)
  ) dut (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(PSEL),
    .PADDR(PADDR),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PREADY(PREADY)
  );

  // Clock generation
  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK; // 100 MHz clock
  end

  // Reset
  initial begin
    PRESETn = 0;
    PSEL = 0;
    PENABLE = 0;
    PWRITE = 0;
    PADDR = 0;
    PWDATA = 0;
    #20;
    PRESETn = 1;
  end

  // Task for write transaction
  task apb_write(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    begin
      @(posedge PCLK);
      PSEL <= 1;
      PWRITE <= 1;
      PADDR <= addr;
      PWDATA <= data;
      PENABLE <= 1;
      @(posedge PCLK);
      while (!PREADY) @(posedge PCLK); // wait until ready
      PENABLE <= 0;
      PSEL <= 0;
    end
  endtask

  // Task for read transaction
  task apb_read(input [ADDR_WIDTH-1:0] addr, output [DATA_WIDTH-1:0] data);
    begin
      @(posedge PCLK);
      PSEL <= 1;
      PWRITE <= 0;
      PADDR <= addr;
      PENABLE <= 1;
      @(posedge PCLK);
      while (!PREADY) @(posedge PCLK); // wait until ready
      data = PRDATA;
      PENABLE <= 0;
      PSEL <= 0;
    end
  endtask

  // Test sequence
  initial begin
    reg [DATA_WIDTH-1:0] read_data;

    // Wait for reset release
    @(posedge PRESETn);
    #10;

    // Write some data
    apb_write(10, 32'hA5A5_5A5A);
    apb_write(20, 32'hDEAD_BEEF);

    // Read back
    apb_read(10, read_data);
    $display("Read data from addr 10: %h", read_data);

    apb_read(20, read_data);
    $display("Read data from addr 20: %h", read_data);

    // Test complete
    #20;
    $finish;
  end

endmodule
