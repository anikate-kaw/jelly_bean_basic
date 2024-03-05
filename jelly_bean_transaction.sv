class jelly_bean_transaction extends uvm_sequence_item;
  typedef enum bit[2:0] { NO_FLAVOR, APPLE, BLUEBERRY, BUBBLE_GUM, CHOCOLATE } flavor_e;
   typedef enum bit[1:0] { RED, GREEN, BLUE } color_e;
   typedef enum bit[1:0] { UNKNOWN, YUMMY, YUCKY } taste_e;
 
   rand flavor_e flavor;
   rand color_e  color;
   rand bit      sugar_free;
   rand bit      sour;
   taste_e       taste;
 
   constraint flavor_color_con {
      flavor != NO_FLAVOR;
      flavor == APPLE     -> color != BLUE;
      flavor == BLUEBERRY -> color == BLUE;
   }
 
   function new(string name = "");
      super.new(name);
   endfunction: new
 
   `uvm_object_utils_begin(jelly_bean_transaction)
      `uvm_field_enum(flavor_e, flavor, UVM_ALL_ON)
      `uvm_field_enum(color_e, color, UVM_ALL_ON)
      `uvm_field_int(sugar_free, UVM_ALL_ON)
      `uvm_field_int(sour, UVM_ALL_ON)
      `uvm_field_enum(taste_e, taste, UVM_ALL_ON)
   `uvm_object_utils_end
endclass: jelly_bean_transaction


class sugar_free_jelly_bean_transaction extends jelly_bean_transaction;
   `uvm_object_utils(sugar_free_jelly_bean_transaction)
 
   constraint sugar_free_con {
      sugar_free == 1;
   }
 
   function new(string name = "");
      super.new(name);
   endfunction: new
endclass: sugar_free_jelly_bean_transaction
