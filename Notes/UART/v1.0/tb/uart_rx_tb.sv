`timescale 1ns / 1ps


module uart_rx_tb;
    import uart_pkg::*;
    
    bit clk;
    bit reset_n;

    // Generate system reference clock
    initial begin 
        clk = 1'b0;
        forever begin 
            #3.33 clk = ~clk;
        end
    end

    // Reuse or instantiate your interface layout
    uart_if rx_if(); 
    assign rx_if.clk = clk;
    assign rx_if.reset_n = reset_n;

    // Instantiate your exact corrected receiver module
    uart_rx_fin uut_rx (
        .clk              (rx_if.clk),
        .reset_n          (rx_if.reset_n),
        .rts_n            (rx_if.rts_n),
        .cts_n            (rx_if.cts_n),
        .rx_valid         (rx_if.rx_valid),          // Driven as an output flag by design
        .rx_data          (rx_if.rx_data),           // Input driven by testbench
        .rx_hold_register (rx_if.rx_hold_register),  // Bind output to interface wire register
        .bclk_pulse       (rx_if.bclk_pulse)
    );

    // Generate Baud Clock oversampling pulse
    task generate_bclk(); 
        forever begin 
            repeat (4) @(posedge clk);
            rx_if.bclk_pulse <= 1'b1;
            @(posedge clk);
            rx_if.bclk_pulse <= 1'b0;
        end
    endtask

    task validate_reset_n(); 
        $display("Asserting reset on Receiver");
        reset_n = 1'b0;
        rx_if.rx_data = 1'b1; // Idle state for serial lines is HIGH
        rx_if.rts_n = 1'b0;
        rx_if.bclk_pulse = 1'b0;
        repeat(5) @(posedge clk);
        $display("Deasserting reset on Receiver");
        reset_n = 1'b1;
    endtask

    task wait_bclk();
        do begin
            @(posedge rx_if.clk);
        end while (!rx_if.bclk_pulse);
    endtask

    // Task to mimic a transmitter driving a full serial frame down the RX pin
    task drive_serial_byte(input logic [7:0] byte_data);
        $display("[DRIVER] Injecting serial frame payload: %0h", byte_data);
        
        // 1. Drive Start Bit (LOW)
        rx_if.rx_data <= 1'b0;
        repeat (16) wait_bclk();

        // 2. Drive 8 Data Bits (LSB First)
        for (int i = 0; i < 8; i++) begin
            rx_if.rx_data <= byte_data[i];
            repeat (16) wait_bclk();
        end

        // 3. Drive Stop Bit (HIGH)
        rx_if.rx_data <= 1'b1;
        repeat (16) wait_bclk();
    endtask

    // Monitoring loop task
    task monitor_parallel_output();
        forever begin
            @(posedge rx_if.clk);
            if (rx_if.rx_valid) begin
                // Check parallel contents against expectation queue
                sb.check_actual(rx_if.rx_hold_register);
            end
        end
    endtask

    uart_scoreboard sb;

    initial begin
        sb = new();
        validate_reset_n();

        fork
            generate_bclk();
            monitor_parallel_output();
        join_none

        // Test 1: Baseline Byte
        sb.push_frame(8'hA5);
        drive_serial_byte(8'hA5);
        repeat(20) @(posedge clk);

        // Test 2: Random Sequence Blocks
        for (int i = 0; i < 5; i++) begin
            automatic logic [7:0] rand_data = $urandom_range(0, 255);
            sb.push_frame(rand_data);
            drive_serial_byte(rand_data);
            repeat ($urandom_range(5, 20)) @(posedge clk); // Varying inter-frame delay
        end

        $display("All Receiver verification tests finished.");
        sb.report();
        $finish;
    end

    // Trace dump configuration 
    initial begin 
        $dumpfile("uart_rx_tb.vcd"); 
        $dumpvars(1, uart_rx_tb.uut_rx);   
    end

endmodule