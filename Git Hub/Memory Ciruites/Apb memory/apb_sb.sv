// apb_uart_sb.sv
class apb_sb extends uvm_scoreboard;
  `uvm_component_utils(apb_sb)
   apb_env_config env_cfg;
// Transcation handle  
  apb_xtn apb_data;
  bit [31:0] apb_wr_data [int];
  bit [31:0]  apb_rd_data [int];
  
  int i=0, j=0, m=0, n=0;
// Declration of TLM_ANALYSIS_FIFO   
  uvm_tlm_analysis_fifo#(apb_xtn)apb_fifo;
  
  extern function new(string name="apb_sb",  uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void check_phase(uvm_phase phase);
  //extern function void check_data();
endclass 

// constructor
function apb_sb::new(string name="apb_sb",  uvm_component parent);
  super.new(name,parent);
  apb_fifo=new("apb_fifo",this);

endfunction:new

//build_phase method
function void apb_sb:: build_phase(uvm_phase phase);
  if (!uvm_config_db#(apb_env_config)::get(this,"*","apb_env_config",env_cfg))
    `uvm_fatal("APB_SB","Not able to get config to scoreboard")
    super.build_phase(phase);
endfunction:build_phase 

//run_phase method
task apb_sb::run_phase(uvm_phase phase);
    
      forever  begin
         apb_fifo.get(apb_data);
         if (apb_data.trans_type==WRITE) begin 
           apb_wr_data[i]= apb_data.wdata; 
           `uvm_info("APB_SB",$sformatf("APB WR data[%0d] Transmitted =%0h",i, apb_wr_data[i]),UVM_MEDIUM)
          i++;
         end else begin 
           apb_rd_data[j]= apb_data.rdata; 
           `uvm_info("APB_SB",$sformatf("APB RD data[%0d] Received =%0h",j, apb_rd_data[j]),UVM_MEDIUM)
          j++;
         end
       end 
   	
endtask:run_phase

//Check_phase
 function void apb_sb::check_phase(uvm_phase phase);
    begin
       super.check_phase(phase);
      // if (env_cfg.data_check_on)
        // check_data();
    end
endfunction:check_phase

/*
//Check_data method
function void apb_uart_sb::check_data();
  begin 
     for (int k=0; k<apb_tx_data.num(); k++) begin
       `uvm_info("APB_UART_SB",$sformatf(" TX Data Count=%0d APB DATA=%0h, UART DATA=%0h", k+1, apb_tx_data[k].wdata[7:0], uart_tx_data[k].tx_data),UVM_NONE)
       if(apb_tx_data[k].wdata[7:0]!=uart_tx_data[k].tx_data)
         `uvm_error("APB_UART_SB","  APB TX DATA DID NOT MATCH WITH UART TX DATA")  
     end 
     $display(" =======================================\n ");
     for (int k=0; k<apb_rx_data.num(); k++) begin
       `uvm_info("APB_UART_SB",$sformatf(" RX Data Count=%0d APB DATA=%0h, UART DATA=%0h", k+1, apb_rx_data[k].rdata[7:0], uart_rx_data[k].rx_data),UVM_NONE)
       if(apb_rx_data[k].rdata[7:0]!=uart_rx_data[k].rx_data)
         `uvm_error("APB_UART_SB","  APB RX DATA DID NOT MATCH WITH UART RX DATA")
        
     end 
  end
endfunction
*/