//APB Driver 
class apb_driver extends uvm_driver #(apb_xtn);
  `uvm_component_utils(apb_driver)
   //Declare virtual interface
  virtual apb_if apb_if_drv;
  apb_agent_config m_cfg;
  bit wait_for_rsp=0;
  
extern function new(string name="apb_driver",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(apb_xtn axtn);
endclass:apb_driver

//Constructor
function apb_driver:: new (string name="apb_driver",uvm_component parent);
  super.new(name,parent);
endfunction

//Build_phase
function void apb_driver::build_phase(uvm_phase phase);
  super.build_phase(phase); if(!uvm_config_db#(apb_agent_config)::get(this,"*","apb_agent_config",m_cfg))
    `uvm_fatal("DRIVER_VIF0","get interface to driver")
  endfunction:build_phase
  
//Connect_phase
function void apb_driver::connect_phase(uvm_phase phase);
  super.connect_phase (phase);
  apb_if_drv=m_cfg.vif0;
endfunction

//run_phase
task apb_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
   
    if (wait_for_rsp) begin
      rsp=new ("rsp");
      rsp.set_id_info(req);
      seq_item_port.put_response(req);
      `uvm_info("APB_DRIVER", $sformatf("req.rdata=%0h ", req.rdata), UVM_MEDIUM)
    end
   
    seq_item_port.item_done();
  end
endtask:run_phase
//Driving the transaction to the DUT
task apb_driver::send_to_dut(apb_xtn axtn);
  begin
   
     // write
     repeat (2) @(posedge apb_if_drv.pclk);
     
     if (axtn.trans_type==WRITE) begin
       `uvm_info("APB_DRIVER",$sformatf("Driving the transaction\n %s",axtn.sprint),UVM_DEBUG)
       apb_if_drv.DRV.driver.psel<=1;
       apb_if_drv.DRV.driver.pwrite<=1;
       apb_if_drv.DRV.driver.penable<=0;
       apb_if_drv.DRV.driver.paddr<=axtn.addr;
       apb_if_drv.DRV.driver.pwdata<=axtn.wdata;
       @(posedge apb_if_drv.pclk);
       apb_if_drv.DRV.driver.penable<=1;
       @(posedge apb_if_drv.pclk);
       while (apb_if_drv.DRV.pready!=1) begin
         @(posedge apb_if_drv.pclk);
       end   
       apb_if_drv.DRV.driver.penable<=0;
       apb_if_drv.DRV.driver.psel<=0;
     end

//read
     if (axtn.trans_type==READ) begin
       apb_if_drv.DRV.driver.psel<=1;
       apb_if_drv.DRV.driver.pwrite<=0;
       apb_if_drv.DRV.driver.penable<=0;
       apb_if_drv.DRV.driver.paddr<=axtn.addr;
       @(posedge apb_if_drv.pclk);
       apb_if_drv.DRV.driver.penable<=1;
       @(posedge apb_if_drv.pclk);
       while (apb_if_drv.DRV.pready!=1) begin
         @(posedge apb_if_drv.pclk);
       end   
       axtn.rdata=apb_if_drv.DRV.prdata;
       apb_if_drv.DRV.driver.penable<=0;
       apb_if_drv.DRV.driver.psel<=0;
       req.rdata=apb_if_drv.DRV.prdata;
       `uvm_info("APB_DRIVER",$sformatf("Driving the transaction\n %s",axtn.sprint),UVM_DEBUG)
     end
  end
endtask:send_to_dut

