`timescale 1ns / 1ns

module dlatch (
    input wire en,
    input wire d,
    output q,
    output  qbar
);
    reg latch;
    always @ (*) begin
        if (en)
            latch<=d;
    end

    assign q = latch;
    assign qbar = ~q;


    
endmodule