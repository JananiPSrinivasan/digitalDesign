`timescale 1ns/1ns

module nbitdecoder #(parameter N = 3)(
	input [N-1:0]a,
	input en,
	output reg [2**N-1:0] y
	);
	
	always @ (*) begin
		if(!en)
			y = 0;
		else
			y = (1 << a);
	end

endmodule