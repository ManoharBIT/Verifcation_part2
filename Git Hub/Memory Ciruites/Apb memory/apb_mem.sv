// APB memory design RTL
module apb_mem  #(parameter ADDR_WIDTH=10, DATA_WIDTH=32, RDY_COUNT=1) (
  input  wire        PCLK,     // Clock
  input  wire        PRESETn,  // Active low reset
  input  wire        PSEL,     // Device select
  input  wire [ADDR_WIDTH-1:0]  PADDR,    // Address
  input  wire        PENABLE,  // Transfer control
  input  wire        PWRITE,   // Write control
  input  wire [DATA_WIDTH-1:0] PWDATA,   // Write data
  output wire [DATA_WIDTH-1:0] PRDATA,   // Read data
  output reg        PREADY );  // Device ready

 // Signals for read/write controls
 wire  read_enable, write_enable;
 reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];  // fix memory size
 integer rdy_count; 

 // Read and write control signals
 assign  read_enable  = PSEL & (~PWRITE) & PENABLE & PREADY ; //Read transaction
 assign  write_enable = PSEL & PWRITE & PENABLE & PREADY;       //Write transaction

 // Memory read
 assign PRDATA = (read_enable)? mem[PADDR] : 'hz;    

 // Memory write 
 always_ff @(posedge PCLK) begin
    if (write_enable)
      mem[PADDR] <= PWDATA;
 end

 // Ready assertion logic with asynchronous reset
 always_ff @(posedge PCLK or negedge PRESETn) begin 
     if (!PRESETn) begin
         PREADY <= 1'b0;
         rdy_count <= 0;
     end else if (rdy_count == RDY_COUNT) begin
         PREADY <= 1'b1;
         rdy_count <= 0;
     end else begin  
         PREADY <= 1'b0;
         rdy_count <= rdy_count + 1;
     end
 end  

endmodule
