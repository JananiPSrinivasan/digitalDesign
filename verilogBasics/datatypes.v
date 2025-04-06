
module datatypes();
	reg [5:0] x= 0;
	reg [5:0] y = 0;
	reg [5:0] z = 0 ;


	/*always @(*) begin
		$display("%b %b %b\n", x,y,z);
	end */

	initial begin 
		$monitor("x=%b, y=%b, z=&b ",x,y,z);
	end
	// Bitwise Operations 
	initial begin
		#1;
		x = 6'b000000;
		y = 6'b111111;
		z = x | y;
		#1;
		z = x & y;
		#1 ;
		z = ~(x | y);
		#1 ;
		z= ~(x & y);
		#1;	
		z = (x^y);
		#1;
		z = ~(x^y);
	end
	
	
	
	//reduction Operations
	

	 
 
endmodule