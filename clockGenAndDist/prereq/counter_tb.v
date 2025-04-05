/* Testbench for counter module  */
/*
  Design Engineer : Janani P Srinivasan
  Design Name : Testbench for 4 bit synchronous upcounter  
*/



`timescale 1ns/1ps
module counter_tb();
   reg clk;
   reg enable ;
   reg rst;
   wire [3:0] count;

   counter #(.WIDTH(4)) uut (
			   .clk(clk),
			   .rst(rst),
			   .enable(enable),
			   .count(count)
			   );
   always #5 clk = ~clk;
   initial begin
      $dumpfile("counter_tb.vcd");
      $dumpvars(0,counter_tb);
      //Initiate signals      
      clk = 0;
      enable =0;
      rst = 1;
      //reset is 1 here, the counter will be reset to 0

      #10;
      rst = 0;
      enable =1;
      #200;
      enable=0;
      #20;
      rst=1;
      enable=1;
      #40;
      rst=0;
      enable = 0;
      #10;
      rst = 1;
      enable =1;
      #10;
      
      rst =0;
      $finish;
          
     
   end
endmodule // counter_tb


   
