`timescale 1ns/1ps

module pipo_reg_tb();
    reg clk =0;
    reg rst;
    reg [3:0] d;
    wire [3:0] q;
    reg [1:0] delay;
    integer i;

    pipo_reg uut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .q(q)
    );

    always begin
    #0.5 clk = ~clk;

    end

    initial begin 
    
    rst = 0; d =0;
    for (i=0;i<4;i++) begin
        delay = $urandom_range(1,3);
        #(delay) d = ~d;
    end
    rst = 1; 
    for (i=0;i<4;i++) begin
        delay = $urandom_range(1,3);
        #(delay) d = ~d;
    end

    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,pipo_reg_tb);
        #40 $finish;
    end

endmodule