class jelly_bean_env extends uvm_env;
   `uvm_component_utils(jelly_bean_env)
 
   jelly_bean_agent         jb_agent;
   jelly_bean_fc_subscriber jb_fc_sub;
   jelly_bean_scoreboard    jb_sb;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      jb_agent  = jelly_bean_agent::type_id::create(.name("jb_agent"), .parent(this));
      jb_fc_sub = jelly_bean_fc_subscriber::type_id::create(.name("jb_fc_sub"), .parent(this));
      jb_sb     = jelly_bean_scoreboard::type_id::create(.name("jb_sb"), .parent(this));
    endfunction: build_phase
 
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      jb_agent.jb_ap.connect(jb_fc_sub.analysis_export);
      jb_agent.jb_ap.connect(jb_sb.jb_analysis_export);
   endfunction: connect_phase
endclass: jelly_bean_env
