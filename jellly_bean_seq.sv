typedef uvm_sequencer#(jelly_bean_transaction) jelly_bean_sequencer;


class one_jelly_bean_sequence extends uvm_sequence#(jelly_bean_transaction);
   `uvm_object_utils(one_jelly_bean_sequence)
 
   function new(string name = "");
      super.new(name);
   endfunction: new
 
   task body();
      jelly_bean_transaction jb_tx;
      jb_tx = jelly_bean_transaction::type_id::create(.name("jb_tx"), .contxt(get_full_name()));
     //start_item initiates a new tx/seq
      start_item(jb_tx);
      assert(jb_tx.randomize());
      finish_item(jb_tx);
   endtask: body
endclass: one_jelly_bean_sequence


class same_flavored_jelly_beans_sequence extends uvm_sequence#(jelly_bean_transaction);
   rand int unsigned num_jelly_beans; // knob
 
   constraint num_jelly_beans_con { num_jelly_beans inside { [2:4] }; }
 
   function new(string name = "");
      super.new(name);
   endfunction: new
 
   task body();
      jelly_bean_transaction           jb_tx;
      jelly_bean_transaction::flavor_e jb_flavor;
 
      jb_tx = jelly_bean_transaction::type_id::create(.name("jb_tx"), .contxt(get_full_name()));
      assert(jb_tx.randomize());
      jb_flavor = jb_tx.flavor;
 
      repeat (num_jelly_beans) begin
         jb_tx = jelly_bean_transaction::type_id::create(.name("jb_tx"), .contxt(get_full_name()));
         start_item(jb_tx);
         assert(jb_tx.randomize() with { jb_tx.flavor == jb_flavor; });
         finish_item(jb_tx);
      end
   endtask: body
 
   `uvm_object_utils_begin(same_flavored_jelly_beans_sequence)
      `uvm_field_int(num_jelly_beans, UVM_ALL_ON)
   `uvm_object_utils_end
endclass: same_flavored_jelly_beans_sequence


class gift_boxed_jelly_beans_sequence extends uvm_sequence#(jelly_bean_transaction);
   rand int unsigned num_jelly_bean_flavors; // knob
 
   constraint num_jelly_bean_flavors_con { num_jelly_bean_flavors inside { [2:3] }; }
 
   function new(string name = "");
      super.new(name);
   endfunction: new
 
   task body();
      same_flavored_jelly_beans_sequence jb_seq;
      repeat (num_jelly_bean_flavors) begin
         jb_seq = same_flavored_jelly_beans_sequence::type_id::create(.name("jb_seq"), .contxt(get_full_name()));
         assert(jb_seq.randomize());
         jb_seq.start(.sequencer(m_sequencer), .parent_sequence(this));
      end
   endtask: body
 
   `uvm_object_utils_begin(gift_boxed_jelly_beans_sequence)
      `uvm_field_int(num_jelly_bean_flavors, UVM_ALL_ON)
   `uvm_object_utils_end
endclass: gift_boxed_jelly_beans_sequence
