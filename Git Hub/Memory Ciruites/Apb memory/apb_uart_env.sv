//apb_uart_env.sv
class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  apb_agent magent;
  apb_sequencer vsqr;
  apb_sb sb;
  apb_env_config env_cfg;

  extern function new(string name="apb_env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  //extern function void end_of_elaboration_phase(uvm_phase phase);
  extern function void report();
endclass:apb_env

// constructor
function apb_env::new(string name="apb_env",uvm_component parent);
  super.new(name,parent);
endfunction:new

//Build_phase
function void apb_env::build_phase(uvm_phase phase);
   //get interface from enviornment config or else through fatal error 
 if (!uvm_config_db#(apb_env_config)::get(this,"*", "apb_env_config",env_cfg))
   `uvm_fatal("APB_ENV_CONFIG","Not able to get environment handle")
 if(env_cfg.has_apb_agent)   
   magent = apb_agent::type_id::create("magent",this);
  if(env_cfg.has_apb_sb)
   sb = apb_sb::type_id::create("sb",this);
   //set intertface to apb agent
   uvm_config_db#(apb_agent_config)::set(this,"*","apb_agent_config",env_cfg.m_cfg);
  
endfunction:build_phase

//Connect_phase
function void apb_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
   if(env_cfg.has_apb_agent)   
     magent.mon.apb_monitor_port.connect(sb.apb_fifo.analysis_export);
   
endfunction:connect_phase

// env report

function void apb_env::report();
  uvm_report_server reportserver = uvm_report_server::get_server(); 
  assert(reportserver.get_severity_count(UVM_FATAL) == 0 && reportserver.get_severity_count(UVM_ERROR) == 0) begin
      `uvm_info (get_type_name(),">>>>>  TEST PASSED", UVM_DEBUG) 
  end else
      `uvm_info (get_type_name(),">>>>>>> TEST FAILED", UVM_DEBUG)
endfunction

