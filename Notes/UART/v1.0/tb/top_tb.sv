`timescale 1ns / 1ps

// Include your scoreboard code structure directly
//`include "uart_scoreboard.sv"

module top_tb;
    import uart_pkg::*;
    
    bit clk;
    bit reset_n;

    // Generate reference clock
    initial begin 
        clk = 1'b0;
        forever begin 
            #3.33 clk = ~clk;
        end
    end

    // Interconnect lines to handle loopback structural mapping
    logic serial_loopback_wire;
    
    // Virtual interface configuration handle
    uart_if top_if(); 
    assign top_if.clk = clk;
    assign top_if.reset_n = reset_n;

    // Output capture lines from receiver side
    logic [7:0] rx_parallel_out;
    logic       rx_data_ready;
    logic       tx_rts_n_out;
    logic       rx_cts_n_out;

    // Instantiate the complete top-level full-duplex hardware system
    uart_top uut_top (
        .clk              (top_if.clk),
        .reset_n          (top_if.reset_n),

        // Parallel Inbound TX paths
        .tx_valid         (top_if.tx_valid),
        .tx_hold_register (top_if.tx_hold_register),
        
        // Parallel Outbound RX paths
        .rx_hold_register (rx_parallel_out),
        .rx_valid         (rx_data_ready),

        // Hardware Handshaking Flow Control Ports
        .tx_cts_n         (top_if.cts_n),
        .tx_rts_n         (tx_rts_n_out),
        .rx_rts_n         (top_if.rts_n),
        .rx_cts_n         (rx_cts_n_out),

        // PHYSICAL HARDWARE EXTERNAL LOOPBACK DEPLOYMENT
        .uart_tx_pin      (serial_loopback_wire), // Serial line output pin
        .uart_rx_pin      (serial_loopback_wire)  // Linked back into serial line input pin
    );

    task validate_reset_n(); 
        $display("Asserting system reset on top block");
        reset_n = 1'b0;
        top_if.tx_hold_register = 8'd0;
        top_if.cts_n = 1'b0; // Always clear to send for transmission tests
        top_if.rts_n = 1'b0;
        top_if.tx_valid = 1'b0;
        repeat(5) @(posedge clk);
        $display("Deasserting system reset on top block");
        reset_n = 1'b1;
    endtask

    // Monitoring task tracking the loopback hardware output data streams
    task monitor_rx_capture();
        forever begin
            @(posedge top_if.clk);
            if (rx_data_ready) begin
                $display("[TOP LEVEL RECONSTRUCTION] Parallel Byte Captured from line: %0h", rx_parallel_out);
                // Push captured parallel byte into your scoreboard array
                sb.check_actual(rx_parallel_out);
            end
        end
    endtask

    uart_transaction tx;
    uart_driver driver; 
    uart_scoreboard sb;

    initial begin 
        driver = new(top_if);
        sb = new(); 
        validate_reset_n();

        // Run parallel tracking engine loop in the background
        fork 
            monitor_rx_capture();
        join_none

                // Test 1: Send a single byte of data
        tx = new();
        tx.data = 8'hA5;
        sb.push_frame(tx.data);
        driver.drive(tx);
        @(posedge rx_data_ready);
        wait (uut_top.transmitter.curr_state == 3'b000);
        repeat (10) @(posedge clk);

        // Test 2: send another byte of data
        tx = new();
        tx.data = 8'h3C;
        sb.push_frame(tx.data);
        driver.drive(tx);
        @(posedge rx_data_ready);
        wait (uut_top.transmitter.curr_state == 3'b000);
        repeat (10) @(posedge clk);

        // Test 3: send all 0
        tx = new();
        tx.data = 8'h00;
        sb.push_frame(tx.data);
        driver.drive(tx);
        @(posedge rx_data_ready);
        wait (uut_top.transmitter.curr_state == 3'b000);
        repeat (10) @(posedge clk);

        // Test 4: send all 1
        tx = new();
        tx.data = 8'hFF;
        sb.push_frame(tx.data);
        driver.drive(tx);
        @(posedge rx_data_ready);
        wait (uut_top.transmitter.curr_state == 3'b000);
        repeat (10) @(posedge clk);

        // Test 5: send random data
        tx = new();
        tx.data = $urandom_range(0, 255);
        sb.push_frame(tx.data);
        driver.drive(tx);
        @(posedge rx_data_ready);
        wait (uut_top.transmitter.curr_state == 3'b000);
        repeat (10) @(posedge clk);

        // Test 6: send a sequence of bytes
        tx = new();
        for (int i = 0; i < 5; i++) begin
            tx.data = $urandom_range(0, 255);
            sb.push_frame(tx.data);
            driver.drive(tx);
            @(posedge rx_data_ready);
            wait (uut_top.transmitter.curr_state == 3'b000);
            repeat (5) @(posedge clk); // Delay between bytes
        end

        // Test 7: send a sequence of bytes with varying delays between them
        tx = new();
        for (int i = 0; i < 5; i++) begin
            tx.data = $urandom_range(0, 255);
            sb.push_frame(tx.data);
            driver.drive(tx);
            @(posedge rx_data_ready);
            wait (uut_top.transmitter.curr_state == 3'b000);
            repeat ($urandom_range(1, 10)) @(posedge clk); // Random delay between bytes
        end

        $display("Top-Level full system loopback verification finished successfully.");
        sb.report();
        $finish;
end
  
        // Watchdog: a full run takes ~6.25 ms; anything far beyond that is a hang
    initial begin
        #20ms;
        $display("ERROR: WATCHDOG TIMEOUT - simulation hung");
        sb.report();
        $finish;
    end

    // Waveform Generation mapping
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(1, top_tb.uut_top);
    end

endmodule
