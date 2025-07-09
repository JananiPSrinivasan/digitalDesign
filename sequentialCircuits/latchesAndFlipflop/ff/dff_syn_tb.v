`timescale 1ns/1ps 

module dff_syn_tb();
    reg clk = 0;
    reg rst;
    reg d;
    wire q;
    wire qbar;

// Initiate a delay variable in the input
// a random delay is pauses the toggling input for a while
// in realtime, the data does not change instantaneously. 

    reg [3:1] delay;
    integer i; 

    dff_syn uut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .q(q),
        .qbar(qbar)
    );

    // create the clock signal.

    always begin
        #0.5 clk = ~clk;    
    end

    initial begin
        // the data is also zero and the reset is also 0;
        // !rst is 1. meaning reset is high and the data cannot be propogated to q
        rst = 0;
        d = 0;
        for (i=0;i<4;i++) begin
            delay = $urandom_range(1,3);
            //a random delay is being generated.
            // after a random delay of some seconds, we flip the d
            // so instead of hardcoding the value of d in every cycle, we randomly flip after a time
            #(delay) d = ~d;
        end

        rst =1;
        //!rst is pulled to zero
        // the value of d is propogated to q
        for (i = 0; i<4;i++) begin
            delay = $urandom_range(1,3);
            #(delay) d = ~d;
        end 

        // now setting some value for d
        d =1'b1;
        #(2);
        rst = 0;        
    end



    initial begin
    $dumpfile("dff.vcd");   // name of the waveform output file
    $dumpvars(0, dff_syn_tb);  // dump all variables in the testbench hierarchy
    #50 $finish;
    end

endmodule
