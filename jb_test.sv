class jelly_bean_configuration extends uvm_object;
   `uvm_object_utils(jelly_bean_configuration)
 
   function new(string name = "");
      super.new(name);
   endfunction: new
endclass: jelly_bean_configuration

///////////////////////////////////////////////////////////
class jelly_bean_test extends uvm_test;
   `uvm_component_utils(jelly_bean_test)
 
   jelly_bean_env jb_env;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      begin
         jelly_bean_configuration jb_cfg;
 
         jb_cfg = new;
         assert(jb_cfg.randomize());
         uvm_config_db#(jelly_bean_configuration)::set
           (.cntxt(this), .inst_name("*"), .field_name("config"), .value(jb_cfg));
         jelly_bean_transaction::type_id::set_type_override(sugar_free_jelly_bean_transaction::get_type());
         jb_env = jelly_bean_env::type_id::create(.name("jb_env"), .parent(this));
      end
   endfunction: build_phase
 
   task run_phase(uvm_phase phase);
      gift_boxed_jelly_beans_sequence jb_seq;
 
      phase.raise_objection(.obj(this));
      jb_seq = gift_boxed_jelly_beans_sequence::type_id::create(.name("jb_seq"), .contxt(get_full_name()));
      assert(jb_seq.randomize());
      `uvm_info("jelly_bean_test", { "\n", jb_seq.sprint() }, UVM_LOW)
      jb_seq.start(jb_env.jb_agent.jb_seqr);
      #10ns ;
      phase.drop_objection(.obj(this));
   endtask: run_phase
endclass: jelly_bean_test
