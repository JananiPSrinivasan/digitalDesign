`timescale 1ns/1ps

module decoder_4to16(
	input [3:0] a,
	output reg [15:0] d
	);

	wire [7:0] d_lower, d_upper;

	decoder DEC1(
		.a(a[2:0]),
		.en(~a[3]),
		.y(d_lower)
	);
	
	decoder DEC2(
		.a(a[2:0]),
		.en(a[3]),
		.y(d_upper)
	);

	always @(*) begin
		d[7:0]   = d_lower;
		d[15:8]  = d_upper;
	end

endmodule
