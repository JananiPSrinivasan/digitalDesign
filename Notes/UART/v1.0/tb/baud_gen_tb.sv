`timescale 1ns/1ps

module baud_gen_tb();
    logic clk;
    logic reset_n;
    logic bpulse;

    localparam int DIVISOR = 977;

    // Instantiate the uut

    mod_gen #(.DIVISOR(DIVISOR)) uut(
        .clk(clk),
        .reset_n(reset_n),
        .bpulse(bpulse)
    );

    /*
        1. Generate a clock signal with a period of 7.5 ns (150 MHz)
        
    */
    initial begin 
        clk = 1'b0;
        forever begin 
            #3.75 clk = ~clk;
            //$display("clk = %b", clk);
        end
    end

    /*
        2. :Generate an active low reset signal
        The reset signal is valid for 10 clock cycles
    */
    initial begin 
        $display("Asserting reset");
        reset_n = 1'b0;
        $display ("reset_n = %b", reset_n);
        repeat(10)@(posedge clk);
        $display("Deasserting reset");
        reset_n = 1'b1;
        $display ("reset_n = %b", reset_n);

        $display ("Running simulation for 2500 cycles");
        repeat(1500)@(posedge clk);

        reset_n = 1'b0;
        @(posedge clk);
        reset_n = 1'b1;
        repeat(1000)@(posedge clk);
        $finish;
    end
    
    /*
        Check if the the register is holding the count value 
    */

    logic [9:0] divisor;
    assign divisor = DIVISOR;
    initial begin 
        $display("DIVISOR = %d", divisor);
    end
       

    logic [9:0] bclk_counter;
    
    always @(posedge clk) begin 
        bclk_counter = uut.bclk_counter;
        if (!reset_n) begin 
            bclk_counter <= 10'd0;
            $display("Resetting bclk_counter to %d", bclk_counter);
        end else begin 
            $display("bclk_counter = %d", uut.bclk_counter);
            if (bclk_counter == divisor -1'b1) begin 
                $display("Baud pulse generated at time %t", $time);
            end
        end
    end

    initial begin 
        
        $dumpfile("baud_gen_tb.vcd");
        $dumpvars(0, baud_gen_tb);
        
    end
endmodule