`timescale 1ns/1ns

module nbitdecoder_tb();
	parameter N=3;
	reg [N-1:0]a;
	reg en;
	wire [2**N-1:0]y;
	
	integer i; 
	
	nbitdecoder #(.N(N)) dut(
		.a(a),
		.en(en),
		.y(y)
	);
	
	initial begin
		$monitor ("%b %b %b",a,en,y);
		for (i=0;i<2**N;i=i+1) begin
			#10; a=i; en=1;
		end
		
	end 

endmodule