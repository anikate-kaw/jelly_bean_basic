// Code your testbench here
// or browse Examples
 import uvm_pkg::*;
 `include "uvm_macros.svh"

`include "jb_pkg.sv"

module top;
   import uvm_pkg::*;
   import jb_pkg::*;
 
   reg clk;
   jelly_bean_if     jb_slave_if(clk);
   jelly_bean_taster jb_taster(jb_slave_if);
  
  /*
   module  tb1;
   dut dut_a (.da(da), .db(db), .clk(dclk));
   bind  designmodule  propertymodule  dpM ( .pa( da ) , .pb( db ) , .pclk( dclk ) );
   endmodule
  */
 
   initial begin // clock generation
     $dumpfile("dump.vcd"); $dumpvars;
      clk = 0;
      #5ns ;
      forever #5ns clk = ! clk;
   end
 
   initial begin
      uvm_resource_db#(virtual jelly_bean_if)::set
        (.scope("ifs"), .name("jelly_bean_if"), .val(jb_slave_if));
     run_test("jelly_bean_test");
   end
endmodule: top
