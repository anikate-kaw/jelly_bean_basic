typedef class jelly_bean_scoreboard;
  
class jelly_bean_fc_subscriber extends uvm_subscriber#(jelly_bean_transaction);
   `uvm_component_utils(jelly_bean_fc_subscriber)
 
   jelly_bean_transaction jb_tx;
 
   covergroup jelly_bean_cg;
      flavor_cp:     coverpoint jb_tx.flavor;
      color_cp:      coverpoint jb_tx.color;
      sugar_free_cp: coverpoint jb_tx.sugar_free;
      sour_cp:       coverpoint jb_tx.sour;
      cross flavor_cp, color_cp, sugar_free_cp, sour_cp;
   endgroup: jelly_bean_cg
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
      jelly_bean_cg = new;
   endfunction: new
 
   function void write(jelly_bean_transaction t);
      jb_tx = t;
      jelly_bean_cg.sample();
   endfunction: write
endclass: jelly_bean_fc_subscriber
 
class jelly_bean_sb_subscriber extends uvm_subscriber#(jelly_bean_transaction);
   `uvm_component_utils(jelly_bean_sb_subscriber)
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void write(jelly_bean_transaction t);
      jelly_bean_scoreboard jb_sb;
 
      $cast( jb_sb, m_parent );
      jb_sb.check_jelly_bean_taste(t);
   endfunction: write
endclass: jelly_bean_sb_subscriber
  
class jelly_bean_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(jelly_bean_scoreboard)
 
  uvm_analysis_export#(jelly_bean_transaction) jb_analysis_export; //why not use analysis port import
   local jelly_bean_sb_subscriber jb_sb_sub;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      jb_analysis_export = new( .name("jb_analysis_export"), .parent(this));
      jb_sb_sub = jelly_bean_sb_subscriber::type_id::create(.name("jb_sb_sub"), .parent(this));
   endfunction: build_phase
 
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      jb_analysis_export.connect(jb_sb_sub.analysis_export);
   endfunction: connect_phase
 
   virtual function void check_jelly_bean_taste(jelly_bean_transaction jb_tx);
      uvm_table_printer p = new;
      if (jb_tx.flavor == jelly_bean_transaction::CHOCOLATE && jb_tx.sour) begin
         if (jb_tx.taste == jelly_bean_transaction::YUCKY) begin
            `uvm_info("jelly_bean_scoreboard",
                       { "You have a good sense of taste.\n", jb_tx.sprint(p) }, UVM_LOW);
         end else begin
            `uvm_error("jelly_bean_scoreboard",
                        { "You lost sense of taste!\n", jb_tx.sprint(p) });
         end
      end else begin
         if (jb_tx.taste == jelly_bean_transaction::YUMMY) begin
            `uvm_info("jelly_bean_scoreboard",
                       { "You have a good sense of taste.\n", jb_tx.sprint(p) }, UVM_LOW);
         end else begin
            `uvm_error("jelly_bean_scoreboard",
                        { "You lost sense of taste!\n", jb_tx.sprint(p) });
         end
      end
   endfunction: check_jelly_bean_taste
endclass: jelly_bean_scoreboard
