`timescale 1ns/1ps
module comparator #(parameter N=4)(
	input [N-1:0]a,
	input [N-1 :0]b,
	output reg smaller,
	output reg greater,
	output reg equal
	);
	
	always @(*) begin
		smaller = (a < b);
		greater = (a > b);
		equal = (a == b);
	end
	
endmodule