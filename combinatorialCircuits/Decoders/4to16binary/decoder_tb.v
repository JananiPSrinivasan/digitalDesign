`timescale 1ns/1ps

module decoder_tb();
	reg [3:0]a;
	//reg en;
	wire [15:0]d;
	integer i;
	
	decoder_4to16 dut (
		.a(a),
		.d(d) 	
	);
	
	initial begin 
		$monitor($time, "%b  %b",a, d);
		for (i=0;i<16;i=i+1) begin
			#10;a=i;
		end
	end

endmodule
