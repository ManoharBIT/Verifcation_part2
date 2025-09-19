/*----------------------------------------------------------
 Class:     	apb sequence class
 Filename:   	apb_sequences.sv
----------------------------------------------------------*/
class apb_sequence extends uvm_sequence #(apb_xtn);
  `uvm_object_utils(apb_sequence)
   apb_env_config env_cfg;
 
 extern function new(string name="apb_sequence");
 extern task body();
/*
  task post_body();
    // drop objection if started as a root sequence
    if(starting_phase != null)
      starting_phase.drop_objection(this);
  endtask */
endclass:apb_sequence

//Constructor 
function apb_sequence :: new(string name="apb_sequence");
  super.new(name);
endfunction:new  

//task body  
task apb_sequence::body();
 // if(!uvm_config_db#(apb_env_config)::get(null,"*","apb_env_config",env_cfg))
   // `uvm_info(get_type_name(),"APB_SEQ env config not obtained",UVM_MEDIUM)
  
  
endtask


// WRITE AND READ SEQUENCE
//---------------------------------------------------------------------------------- 
class apb_write_read_check_seq extends apb_sequence;
   `uvm_object_utils(apb_write_read_check_seq)
   extern function new(string name="apb_write_read_check_seq");
   extern task body(); 
 endclass:apb_write_read_check_seq
 
 function apb_write_read_check_seq::new(string name="apb_write_read_check_seq");
   super.new(name);
 endfunction:new

//apb_write_read_check method
 task apb_write_read_check_seq::body();
   int data;
   super.body();
   req=apb_xtn::type_id::create("req");
   //env_cfg.data_check_on=0;
   for (int trans_count=0; trans_count<10; trans_count++) begin 
   begin
    
       start_item(req);            //control register write
       assert (req.randomize()with {addr== 10'h4+trans_count*4;
                                    trans_type==WRITE;
                         			                
                                  });
       finish_item(req);
   
   end
   data=req.wdata;
   
   begin
     start_item(req);            //control register read
     assert (req.randomize()with {addr==10'h4+trans_count*4;
                                  trans_type==READ;
                                  //wdata==7'h7F;
	    			  });
     finish_item(req);
   end
 end
endtask:body 


