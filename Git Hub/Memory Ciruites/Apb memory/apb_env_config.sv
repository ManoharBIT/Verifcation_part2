// env config
class apb_env_config extends uvm_object;
   `uvm_object_utils(apb_env_config)

   bit has_apb_agent=1;
   bit has_apb_sb=1;
   bit has_virt_sequencer=0;
   bit data_check_on=0;


  //abp aget configuration handles
  apb_agent_config m_cfg;
  extern function new(string name="apb_env_config");
endclass

//Constrctor
function apb_env_config :: new(string name="apb_env_config");
   super.new(name);
endfunction:new
