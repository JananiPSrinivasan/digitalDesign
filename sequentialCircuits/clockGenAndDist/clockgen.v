`timescale 1ns/1ns

module clkgen();

//Testbench variables

parameter HALF_PERIOD_CLK1= 5;
parameter HALF_PERIOD_CLK2=2.5;

reg clk1;
reg clk2=0;
reg clk3;

//create stimulus

initial begin
    clk1 =0;
    forever begin
        //clk1 =0;
        #(HALF_PERIOD_CLK1);
        clk1= ~ clk1;
        
    end
end

always  begin
    #HALF_PERIOD_CLK2; 
    clk2= ~clk2;
end

// Stop simulation after 10ms
initial begin
    #50 $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, clkgen);
end



endmodule
