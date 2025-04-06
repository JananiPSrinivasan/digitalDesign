`timescale 1ns/1ps
module treeAdder(
	input [3:0]  a,
	input [3:0]  b,
	input [7:0]  c,
	input [7:0]  d,
	output reg [4:0] op1,
	output reg [8:0] op2,
	output reg [9:0] sum 
	);
	
	always @(a or b) begin
		op1 = a + b;
	end
	always @ (c or d) begin
		op2 = c + d; 
	end
	
	always @(*) begin
		sum = op1 + op2;
	end
endmodule
