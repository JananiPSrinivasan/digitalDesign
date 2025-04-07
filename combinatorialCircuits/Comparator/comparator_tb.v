`timescale 1ns/1ns
module comparator_tb();
	parameter N=4;
	reg [N-1:0] a;
	reg [N-1:0] b;
	wire smaller;
	wire greater;
	wire equal;
	
	comparator #(.N(N)) dut(
		.a(a),
		.b(b),
		.smaller(smaller),
		.greater(greater),
		.equal(equal)
	);
	
	initial begin
		$monitor ($time,"a=%d b=%d smaller=%d greater=%d equal=%d", a,b,smaller,greater,equal);
	
		#10;a=0;b=0;
		#10;a=3;b=15;
		#10;a=12;b= 9;
		#10;a=13 ;b= 13;
		#10; $stop;
	
	end
	
endmodule