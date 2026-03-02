// Testbench
module tb_rtl1;
    logic clk, rst_n,sig_in;
    logic rise_pulse, fall_pulse, toggle_pulse;
    
    // TODO: Declare signals
    
    // DUT instantiation
    // TODO: Instantiate your design
    rtl1_edge_toggle_detector dut (
      .clk(clk),
      .rst_n(rst_n),
      .sig_in(sig_in),
      .rise_pulse (rise_pulse),
      .fall_pulse(fall_pulse),
      .toggle_pulse(toggle_pulse)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst_n = 1;
        #20 rst_n = 0;
        
        // TODO: Add Test Cases
        #15 sig_in = 1;
        #10 sig_in = 0;
        #15 sig_in = 1;
        
        #1000 $finish;
    end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_rtl1);
    end
    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b rst=%b", $time, clk, rst_n);
    end
endmodule