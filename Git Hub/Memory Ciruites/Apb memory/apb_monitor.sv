// Filename:  apb_monitor.sv
class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  virtual apb_if.MON vif0;
  apb_agent_config m_cfg;
  uvm_analysis_port #(apb_xtn) apb_monitor_port;
  apb_xtn data_sent;
  apb_xtn xtn=new;
  
   covergroup apb_cover; 
     option.per_instance=1;
     addr:coverpoint xtn.addr;
     trans_type:coverpoint xtn.trans_type;
     wdata:coverpoint xtn.wdata{ bins datagrp_0={[0:32'h0000_FFFF]};
                                bins datagrp_1={[32'h0001_0000:32'h00FF_FFFF]};
                                bins datagrp_2={[32'h0100_0000:32'h00FF_FFFF]};}	
     rdata:coverpoint xtn.rdata {  bins datagrp_0={[0:32'h0000_FFFF]};
                                 bins datagrp_1={[32'h0001_0000:32'h00FF_FFFF]};
                                 bins datagrp_2={[32'h0100_0000:32'h00FF_FFFF]};}	
              
   endgroup
   extern function new(string name="apb_monitor", uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
   extern task collect_data();
endclass:apb_monitor

// constructor
function apb_monitor::new(string name="apb_monitor", uvm_component parent);
  super.new(name,parent);
  apb_monitor_port= new("apb_monitor_port",this);
  apb_cover = new();
endfunction:new

// build phase
function void apb_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",m_cfg))
    `uvm_fatal("APB MON","Not able to get Config to monitor")
endfunction:build_phase

// Connect_phase
function void apb_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif0=m_cfg.vif0;
endfunction:connect_phase

//Run_phase
task apb_monitor::run_phase(uvm_phase phase);
     begin
        collect_data();
     end
endtask:run_phase

// collect data task
task apb_monitor::collect_data();
  int en_count=0, dis_count=0;
  data_sent=apb_xtn::type_id::create("data_sent",this);
  begin
    forever begin
       @(posedge vif0.pclk)
       if (vif0.psel==1 && vif0.penable==1 && vif0.pready==1) begin
          if(vif0.pwrite==1 ) begin
                data_sent.trans_type  = WRITE;
                data_sent.addr   =   vif0.paddr;
                data_sent.wdata  =   vif0.pwdata;
          end else begin
                data_sent.trans_type  =  READ; 
                data_sent.addr   =   vif0.paddr;
                data_sent.rdata  =   vif0.prdata;     
          end 
          `uvm_info("APB_MON",$sformatf("  APB Transaction \n %s",data_sent.sprint),UVM_MEDIUM) 
           apb_monitor_port.write(data_sent); 
           
          xtn=data_sent; 
          apb_cover.sample();  
       end  
    end 
  end
endtask:collect_data
