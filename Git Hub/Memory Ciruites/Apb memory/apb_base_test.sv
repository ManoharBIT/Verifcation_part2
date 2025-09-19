// APB UART Base Test 
//-----------------------------------------
class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  // test contains both env and agent config 
  apb_agent_config m_cfg;
  
  apb_env_config env_cfg;
  // Environment handle  
  apb_env envh;

  extern function new (string name="apb_base_test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

// constructor
function apb_base_test::new (string name="apb_base_test", uvm_component parent);
   super.new(name,parent);
endfunction:new

// build phase
function void apb_base_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
   envh	  =  apb_env::type_id::create("envh",this);
   m_cfg  =  apb_agent_config::type_id::create("m_cfg");
  
   env_cfg =  apb_env_config::type_id::create("env_cfg");
   // Connect virtual interface to agent interface or else fatal error
   if(!uvm_config_db#(virtual apb_if)::get(this,"*","vif0",m_cfg.vif0))
      `uvm_fatal ("VIF0_CONFIG","Not set virtual interface to apb interface")
   
  
   // Control agent from test by agent config handle(active or passive)   
    m_cfg.is_active=UVM_ACTIVE;   //APB active 
   
    env_cfg.m_cfg=m_cfg;
    
    uvm_config_db#(apb_env_config)::set(this,"*","apb_env_config",env_cfg);  
endfunction:build_phase

function void apb_base_test:: end_of_elaboration_phase(uvm_phase phase);
  //   super.end_of_elaboration_phase(phase);
   uvm_top.print_topology;
endfunction:end_of_elaboration_phase

 
//apb_write_read_test
//-----------------------------------------
class apb_write_read_test extends apb_base_test;
   `uvm_component_utils(apb_write_read_test)

  // Virtual Sequence Handle    
  apb_write_read_check_seq v_seq;
    
  extern function new(string name="apb_write_read_test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass:apb_write_read_test  

//constructor
  function apb_write_read_test::new(string name="apb_write_read_test", uvm_component parent);
    super.new(name,parent);
  endfunction:new

//Build_phase method
  function void apb_write_read_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

//run_phase method  
  task apb_write_read_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    v_seq=apb_write_read_check_seq::type_id::create("v_seq");
    v_seq.start(envh.magent.sqr);
    phase.drop_objection(this);
  endtask:run_phase 

