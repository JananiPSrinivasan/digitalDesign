/* Design of Synchronous up  counter */

// parameter is a keyword that is used to define the constants
// # (parameter <variable_name> = <value>), where # is a processor directive
module counter #( parameter WIDTH = 4)(
				       input wire  clk,
				       input wire  rst,
				       input wire  enable,
				       output reg[WIDTH-1:0] count
				       );
   always @(posedge clk or posedge rst) begin
      if(rst)
	count <= 0;
      else if (enable)
	count <= count+1;   
   end
endmodule // counter

