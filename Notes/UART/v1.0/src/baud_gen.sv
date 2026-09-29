/* 1. BAUD  GENERATOR

The baud genrator generates baud pulses. 
It either takes in the divisor from the firmware or uses the default one
Baud rate = 9600
clk 150Mhz
	
*/ 	

module mod_gen #(parameter int DIVISOR = 977)(
    input logic clk,
    input logic reset_n,
    output logic bpulse
);


logic [9:0] divisor;
logic [9:0] bclk_counter;

always_ff @(posedge clk) begin 
    if(!reset_n) begin 
        divisor <= DIVISOR;
        bclk_counter <= 10'd0;
        bpulse <= 1'b0;
    end else begin 
       bpulse <= 1'b0;
       if (bclk_counter == divisor -1'b1) begin 
            bclk_counter <= 10'd0;
            bpulse <= 1'b1;
       end
       else begin 
            bclk_counter <= bclk_counter +1'b1;
       end
    end
end


endmodule