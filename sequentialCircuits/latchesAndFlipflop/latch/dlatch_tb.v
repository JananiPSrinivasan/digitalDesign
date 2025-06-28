`timescale 1ns/1ns

module dlatch_tb();
    
    // Initiate the testbench variables
    reg d;
    reg en;
    wire q;
    wire qbar;

    // Instantiate the uut
    dlatch uut(
        .d (d),
        .en (en),
        .q(q),
        .qbar(qbar)
    );

    //Create Stimulus

    initial begin
        $monitor ($time , "\t en = %b, d = %b ,q = %b ,qbar = %b",en,d,q,qbar);
        en=0; d=0;
        #1; d =0;
        #1; d = 1;
        #1.5; en =1;
        #0.2;d=0;
        #0.3;d=1;
        #1;en=0;d=0;
        #1;en=1;d=1;
        #2;d=0;
        #1;en=0;
        #1;d=1;
    end

    initial begin
        #10 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, dlatch_tb);
    end

endmodule