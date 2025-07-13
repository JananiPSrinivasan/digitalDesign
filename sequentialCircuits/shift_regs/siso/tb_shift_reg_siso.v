
`timescale 1us/1ns
module tb_shift_reg_siso();
	
	// Testbench variables
    reg sdi;
	reg clk = 0;
	reg reset_n;
	wire sdo;
	
	// Instantiate the DUT
    shift_reg_siso SISO0(
		.reset_n(reset_n),
	    .clk    (clk    ),
        .sdi    (sdi    ),
	    .sdo    (sdo    )
    );
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin
    	sdi = 0;
    	reset_n = 0; 
    	#1.3; 
    	reset_n = 1;

    	sdi = 1; @(posedge clk); // Clock 1: shift in '1'
    	sdi = 0; @(posedge clk); // Clock 2: shift in '0'
    	sdi = 1; @(posedge clk); // Clock 3: shift in '1'
    	sdi = 0; @(posedge clk); // Clock 4: shift in '0'
	end
	
    // This will stop the simulator when the time expires
    initial begin
		$dumpfile("wave.vcd");
        $dumpvars(0,tb_shift_reg_siso);
        #40 $finish;
    end  
endmodule
