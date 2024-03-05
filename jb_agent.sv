class jelly_bean_driver extends uvm_driver#(jelly_bean_transaction);
   `uvm_component_utils(jelly_bean_driver)
 
   virtual jelly_bean_if jb_vi;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      void'(uvm_resource_db#(virtual jelly_bean_if)::read_by_name
           (.scope("ifs"), .name("jelly_bean_if"), .val(jb_vi)));
   endfunction: build_phase
 
   task run_phase(uvm_phase phase);
      jelly_bean_transaction jb_tx;
 
      forever begin
         @jb_vi.master_cb;
         jb_vi.master_cb.flavor <= jelly_bean_transaction::NO_FLAVOR;
         seq_item_port.get_next_item(jb_tx);
         @jb_vi.master_cb;
         jb_vi.master_cb.flavor     <= jb_tx.flavor;
         jb_vi.master_cb.color      <= jb_tx.color;
         jb_vi.master_cb.sugar_free <= jb_tx.sugar_free;
         jb_vi.master_cb.sour       <= jb_tx.sour;
         seq_item_port.item_done();
      end
   endtask: run_phase
endclass: jelly_bean_driver


class jelly_bean_monitor extends uvm_monitor;
   `uvm_component_utils(jelly_bean_monitor)
 
   uvm_analysis_port#(jelly_bean_transaction) jb_ap;
 
   virtual jelly_bean_if jb_vi;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      void'(uvm_resource_db#(virtual jelly_bean_if)::read_by_name
           (.scope("ifs"), .name("jelly_bean_if"), .val(jb_vi)));
      jb_ap = new(.name("jb_ap"), .parent(this));
   endfunction: build_phase
 
   task run_phase(uvm_phase phase);
      forever begin
         jelly_bean_transaction jb_tx;
         @jb_vi.slave_cb;
         if (jb_vi.slave_cb.flavor != jelly_bean_transaction::NO_FLAVOR) begin
            jb_tx = jelly_bean_transaction::type_id::create(.name("jb_tx"), .contxt(get_full_name()));
            jb_tx.flavor     = jelly_bean_transaction::flavor_e'(jb_vi.slave_cb.flavor);
            jb_tx.color      = jelly_bean_transaction::color_e'(jb_vi.slave_cb.color);
            jb_tx.sugar_free = jb_vi.slave_cb.sugar_free;
            jb_tx.sour       = jb_vi.slave_cb.sour;
            @jb_vi.master_cb;
            jb_tx.taste = jelly_bean_transaction::taste_e'(jb_vi.master_cb.taste);
            jb_ap.write(jb_tx);
         end
      end
   endtask: run_phase
endclass: jelly_bean_monitor


class jelly_bean_agent extends uvm_agent;
   `uvm_component_utils(jelly_bean_agent)
 
   uvm_analysis_port#(jelly_bean_transaction) jb_ap;
 
   jelly_bean_sequencer jb_seqr;
   jelly_bean_driver    jb_drvr;
   jelly_bean_monitor   jb_mon;
 
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new
 
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
 
      jb_ap = new(.name("jb_ap"), .parent(this));
      jb_seqr = jelly_bean_sequencer::type_id::create(.name("jb_seqr"), .parent(this));
      jb_drvr = jelly_bean_driver::type_id::create(.name("jb_drvr"), .parent(this));
      jb_mon  = jelly_bean_monitor::type_id::create(.name("jb_mon"), .parent(this));
   endfunction: build_phase
 
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      jb_drvr.seq_item_port.connect(jb_seqr.seq_item_export);
      jb_mon.jb_ap.connect(jb_ap);
   endfunction: connect_phase
endclass: jelly_bean_agent
