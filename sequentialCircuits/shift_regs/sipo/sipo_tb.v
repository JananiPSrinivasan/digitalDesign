module sipo_tb();
    reg reset_n;
    reg clk=0;
    reg d;
    wire [3:0]q;
    integer i;
    reg [1:0] delay;
    
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
        reset_n = 0; d =0;
        for (i=0;i<4;i++) begin
            delay = $urandom_range(1,3);
            #(delay) d = ~d;
        end
        reset_n = 1; 
        for (i=0;i<4;i++) begin
            delay = $urandom_range(1,3);
            #(delay) d = ~d;
        end

    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,sipo_tb);
        #40 $finish;

    end 

endmodule
