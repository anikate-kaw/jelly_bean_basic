
   typedef enum bit[2:0] { NO_FLAVOR, APPLE, BLUEBERRY, BUBBLE_GUM, CHOCOLATE } flavor_e;
   typedef enum bit[1:0] { RED, GREEN, BLUE } color_e;
   typedef enum bit[1:0] { UNKNOWN, YUMMY, YUCKY } taste_e;

interface jelly_bean_if(input bit clk);
   logic [2:0] flavor;
   logic [1:0] color;
   logic       sugar_free;
   logic       sour;
   logic [1:0] taste;
 
   clocking master_cb @ (posedge clk);
      default input #1step output #1ns;
      output flavor, color, sugar_free, sour;
      input  taste;
   endclocking: master_cb
 
   clocking slave_cb @ (posedge clk);
      default input #1step output #1ns;
      input  flavor, color, sugar_free, sour;
      output taste;
   endclocking: slave_cb
 
   modport master_mp(input clk, taste, output flavor, color, sugar_free, sour);
   modport slave_mp(input clk, flavor, color, sugar_free, sour, output taste);
   modport master_sync_mp(clocking master_cb);
   modport slave_sync_mp(clocking slave_cb);
endinterface: jelly_bean_if


module jelly_bean_taster( jelly_bean_if.slave_mp jb_slave_if );
//   import jb_pkg::*;
   always @ ( posedge jb_slave_if.clk ) begin
     if ( jb_slave_if.flavor == flavor_e'(CHOCOLATE) &&
           jb_slave_if.sour ) begin
       jb_slave_if.taste <= taste_e'(YUCKY);
      end else begin
        jb_slave_if.taste <= taste_e'(YUMMY);
      end
   end
endmodule: jelly_bean_taster
