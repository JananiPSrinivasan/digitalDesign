`timescale 1ns/1ps
module treeAdder_tb();
	reg [3:0] a;
	reg [3:0] b;
	reg [7:0] c;
	reg [7:0] d;
	
	wire [4:0] op1;
	wire [8:0] op2;
	wire [9:0] sum;
	
	treeAdder dut(
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.op1(op1),
		.op2(op2),
		.sum(sum)		
	);
	
	initial begin
		$monitor("a=%d b=%d c=%d d=%d op1=%d op2=%d sum=%d \n",a,b,c,d,op1,op2,sum);
		#10; a=4'd0;  b=4'd3;  c=8'd1;   d=8'd255;
		#10; a=4'd10; b=4'd13; c=8'd9;   d=8'd10;
		#10; a=4'd15; b=4'd15; c=8'd109; d=8'd37;
		#10; a=4'd0;  b=4'd9;  c=8'd45;  d=8'd45;
		
	end
	
	
endmodule
	