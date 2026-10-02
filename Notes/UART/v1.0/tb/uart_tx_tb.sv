module uart_tx_tb;
    import uart_pkg::*;
    
    bit clk;
    bit reset_n;

    // generate clock
    initial begin 
        clk = 1'b0;
        forever begin 
            #3.75 clk = ~clk;
        end
    end

    // now this clk has to go into the actual interface
    // how?
    // inistantiate the interface

    uart_if tx_if(); // this is the interface instantiated.
    // You do not need virtual here because this is the actual hardware block

    // now since the interface is intantiated dribe the clk and reset
    
    assign tx_if.clk = clk;
    assign tx_if.reset_n = reset_n;

    // Instantiate the  module under test

    uart_tx_fin uut();
endmodule