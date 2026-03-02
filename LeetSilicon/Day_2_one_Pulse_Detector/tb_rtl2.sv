// Testbench
module tb_rtl2;
    logic clk, rst_n, sig_in, onecycle_pulse;
    
    // TODO: Declare signals
    
    // DUT instantiation
    // TODO: Instantiate your design
   rtl2_one_cycle_pulse dut (
    .clk(clk),
    .rst_n(rst_n),
    .sig_in(sig_in),
    .onecycle_pulse (onecycle_pulse)
   );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; rst_n = 0;
        sig_in =0;
        #10 rst_n = 1;
        
        // TODO: Add Test Cases
        // Case 1: Valid
        //@(posedge) sig_in = 0;
        @(posedge clk) sig_in <= 1;
        @(posedge clk) sig_in <= 0;
        // Case 2: Two-cycle High
        
        @(posedge clk)sig_in <= 1;
        @(posedge clk)sig_in <= 1;
        @(posedge clk)sig_in <= 0;
        //Case 3: Stuck high

        #50;
        @(posedge clk) sig_in <= 1;
        repeat(4) @(posedge clk);
        sig_in <= 0;

        
        #1000 $finish;
    end
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_rtl2);
    end
    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b rst_n=%b sig_in=%b pulse=%b", $time, clk, rst_n, sig_in , onecycle_pulse);
    end
endmodule