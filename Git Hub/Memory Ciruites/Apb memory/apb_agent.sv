// Agent example
class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)

   apb_agent_config m_cfg; 
   apb_sequencer sqr;
   apb_driver drv;
   apb_monitor mon;
  
  // Analysis port for data broadcast
  uvm_analysis_port #(apb_xtn) apb_monitor_port;
   
  //Methods
  extern function new(string name="apb_agent", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass:apb_agent

 //Constructor
 function apb_agent :: new(string name="apb_agent", uvm_component parent);
    super.new(name,parent);
    apb_monitor_port= new("apb_monitor_port",this);
endfunction:new

//Build_phase
function void apb_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db#(apb_agent_config)::get(this,"*", "apb_agent_config", m_cfg))
     `uvm_fatal("APB AGENT","get interface to agent")
      mon=apb_monitor::type_id::create("mon",this);
      if(m_cfg.is_active==UVM_ACTIVE) begin
           sqr=apb_sequencer::type_id::create("sqr",this);
           drv=apb_driver::type_id::create("drv",this);
      end
endfunction:build_phase
//Connect_phase
function void apb_agent ::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(m_cfg.is_active==UVM_ACTIVE)   begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
    mon.apb_monitor_port.connect(apb_monitor_port);

endfunction:connect_phase
