module sipo_tb();
    reg reset_n;
    reg clk;
    reg d;
    wire [3:0]q;

    sipo uut (
        .clk(clk),
        .rst_n (reset_n),
        .serial_data_in (d),
        .q(q)
    );

    always begin 
        #0.5 clk = ~clk;
    end

    initial begin
         

    end 

endmodule
