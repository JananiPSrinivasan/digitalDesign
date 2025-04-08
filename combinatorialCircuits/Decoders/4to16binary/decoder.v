`timescale 1ns/1ps
module decoder(
	input [2:0]a,
	input en,
	output [7:0] y
	);

	reg [7:0] temp;
	assign y = temp;

	always @ (*) begin
		if (en == 0) 
			temp = 8'b00000000;
		else begin
			case (a)
				3'b000 : temp = 8'b00000001;
				3'b001 : temp = 8'b00000010;
				3'b010 : temp = 8'b00000100;
				3'b011 : temp = 8'b00001000;
				3'b100 : temp = 8'b00010000;
				3'b101 : temp = 8'b00100000;
				3'b110 : temp = 8'b01000000;
				3'b111 : temp = 8'b10000000;
				default: temp = 8'b0;
			endcase
		end 
	end
endmodule
