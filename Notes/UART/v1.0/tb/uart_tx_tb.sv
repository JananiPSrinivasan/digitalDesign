    module uart_tx_tb;
        import uart_pkg::*;
        
        bit clk;
        bit reset_n;

        // generate clock
        initial begin 
            clk = 1'b0;
            forever begin 
                #3.33 clk = ~clk;
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

        uart_tx_fin uut(
        .clk              (tx_if.clk),
        .reset_n          (tx_if.reset_n),

        .cts_n            (tx_if.cts_n),
        .rts_n            (tx_if.rts_n),

        .tx_valid         (tx_if.tx_valid),

        .tx_hold_register (tx_if.tx_hold_register),
        .tx_data          (tx_if.tx_data),

        .rx_data          (tx_if.rx_data),

        .bclk_pulse       (tx_if.bclk_pulse)
        );


        task generate_bclk(); 
            forever begin 
                repeat (4) @(posedge clk);
                tx_if.bclk_pulse <= 1'b1;
                @(posedge clk);
                tx_if.bclk_pulse <= 1'b0;
            end
        endtask
        task validate_reset_n(); 
           // forever begin 
                $display("Asserting reset");
                reset_n = 1'b0;
//                tx_if.clk = 1'b0;
                tx_if.tx_hold_register = 8'd0;
                tx_if.cts_n=1'b1;
                tx_if.rx_data = 1'b1;
                tx_if.bclk_pulse = 1'b0;

                repeat(5) @(posedge clk);
                $display("Deasserting reset");
                reset_n = 1'b1;
                tx_if.cts_n = 1'b0;
                tx_if.tx_valid = 1'b0;
           // end

        endtask
 
 
         task wait_bclk() ;
            do begin 
                @(posedge tx_if.clk);
            end
            while (!tx_if.bclk_pulse);
        endtask       
        
        task uart_bit_check(
            input logic expected_bit, 
            input string bit_name
        ); 

        repeat (16) begin 
            wait_bclk();
            //#1ps;
            //@(posedge tx_if.bclk_pulse);
            if (tx_if.tx_data !== expected_bit) begin 
                $display ("ERROR: [%0t] %s FAILED: expected = %b, actual = %b", $time, bit_name, expected_bit, tx_if.tx_data);
            end else begin 
                $display ("INFO: [%0t] %s PASSED: expected = %b, actual = %b", $time, bit_name, expected_bit, tx_if.tx_data);
             end
        end 
        
        endtask
        
        // helper task
        

        task uart_frame_check(input logic [7:0] expected_data); 
            logic [7:0] captured_data;
            // check start bit
            wait(tx_if.tx_data == 1'b0);
            uart_bit_check(1'b0, "START BIT");
            // check data bits
            for (int i = 0; i < 8; i++) begin 
                uart_bit_check(expected_data[i], $sformatf("DATA BIT %0d", i));
                captured_data[i] = tx_if.tx_data;
            end
            // check stop bit
            uart_bit_check(1'b1, "STOP BIT");
            sb.check_actual(captured_data);
        endtask


    //-----------------------------------------------------------------------------------//
        // we need two objects 
        uart_transaction tx;
        uart_driver driver; // the object of driver class which has the drive taks in that
        uart_scoreboard sb;

        // refer the driver file. 
        // uart driver needs an interface to drive the data
        // the new function in the driver class holds the interface handle
            // function new(virtual uart_if pif)
        // drive task in the driver class is called in the testbench with a transaction object as input
        // this task will send the data to the data tx hold register via the interface handle.

        initial begin 
            driver = new(tx_if);
            sb = new(); // this tx_if becomes a virtual handle in the driver class
            validate_reset_n();

            fork 
                generate_bclk();
            join_none

            // Test case 1: Send a single byte of data
            tx = new(); 
            tx.data = 8'hA5; // Example data to send
            sb.push_frame (tx.data);
            fork 
                driver.drive (tx);
                uart_frame_check(tx.data);
            join

            repeat (10) @(posedge clk); 
            
            //Test 2: send another byte of data
            tx = new();
            tx.data = 8'h3C;
            sb.push_frame (tx.data);
            fork 
                driver.drive (tx);
                uart_frame_check(tx.data);
            join

            repeat (10) @(posedge clk);

            //Test 3: send all 0

            tx = new();
            tx.data = 8'h00;
            sb.push_frame (tx.data);
            fork 
                driver.drive (tx);
                uart_frame_check(tx.data);
            join

            repeat (10) @(posedge clk);
            //Test 4: send all 1

            tx = new();
            tx.data = 8'hFF;
            sb.push_frame(tx.data);
            fork 
                driver.drive (tx);
                uart_frame_check(tx.data);
            join
            //Test 5: send random data
            tx = new();
            tx.data = $urandom_range(0, 255);
            sb.push_frame (tx.data);
            fork 
                driver.drive (tx);
                uart_frame_check(tx.data);
            join

            //Test 6: send a sequence of bytes
            tx = new();
            for (int i = 0; i < 5; i++) begin
                tx.data = $urandom_range(0, 255);
                sb.push_frame (tx.data);
                fork 
                    driver.drive (tx);
                    uart_frame_check(tx.data);
                join
                repeat (5) @(posedge clk); // Delay between bytes
            end

            //Test 7: send a sequence of bytes with varying delays between them
            tx = new();
            for (int i = 0; i < 5; i++) begin
                tx.data = $urandom_range(0, 255);
                sb.push_frame (tx.data);
                fork 
                    driver.drive(tx);
                    uart_frame_check(tx.data);
                join
                repeat ($urandom_range(1, 10)) @(posedge clk); // Random delay between bytes
            end
            $display("All tests done");
            sb.report();
            $finish;
        end

        // Waveform generation
        initial begin
        
            $dumpfile("uart_tx_tb.vcd");
            $dumpvars(1, uart_tx_tb);
        end

    endmodule