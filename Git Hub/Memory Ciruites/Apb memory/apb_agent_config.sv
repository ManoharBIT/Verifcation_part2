// Apb Agent configuration 
class apb_agent_config extends uvm_object; 
  `uvm_object_utils(apb_agent_config)

   virtual apb_if vif0; 
   uvm_active_passive_enum is_active=UVM_ACTIVE;
   

   extern function new (string name = "apb_agent_config");
endclass : apb_agent_config

//Constructor
function apb_agent_config::new(string name="apb_agent_config");
   super.new(name);
endfunction : new
