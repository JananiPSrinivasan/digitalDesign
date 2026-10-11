`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2026 16:21:54
// Design Name: 
// Module Name: uart_scoreboard
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//typedef logic [7:0] scoreboard_queue_t[$];
class uart_scoreboard;

    logic [7:0] expected_q [$];
    int items_checked=0;
    int items_pushed=0;
    int match_count=0;
    int error_count=0;
    
    // temporary var for covergroup
    logic [7:0] sampled_data;
    
    covergroup uart_cg; 
    // Coverpoint 1 to Track every single state. 256 state because 0 to 255
        cp_data : coverpoint sampled_data {
            bins all_values = {[0:255]};
        }
        
        cp_corners : coverpoint sampled_data{
            bins zero_val = {8'h00};
            bins ones_val = {8'hFF};
            bins alternating = {8'hA5, 8'h5A};
             
        }
    
    endgroup
    
    function new();
        uart_cg = new();
    endfunction
    
    
    function void push_frame(logic [7:0] actual_data);
        expected_q.push_back(actual_data);
        items_pushed++;
    endfunction
    
    function void check_actual(logic [7:0] actual_data);
        logic [7:0] expected_data;
        items_checked++;
        
        if (expected_q.size()==0) begin 
            $display ("ERROR: Unexpected data seen on TX line");
            error_count++;
        end
        
        expected_data = expected_q.pop_front();
        
        if (actual_data == expected_data) begin 
            $display("DATA MATCHED: EXPECTED = %0h | ACTUAL = %0h", expected_data, actual_data);
            match_count++;
            this.sampled_data = actual_data;
            uart_cg.sample();
        end else begin 
            $display("DATA MISMATCH: EXPECTED = %0h | ACTUAL = %0h",expected_data, actual_data);
            error_count++;
        end
    endfunction
    
    function void report();
        
        if(expected_q.size()>0) begin 
            $display("ERROR : %0d frames left in queue", expected_q.size());
            error_count++;
        end
        $display ("FRAMES PUSHED: %0d", items_pushed);
        $display ("FRAMES CHECKED: %0d", items_checked);
        $display ("FRAMES MATCHED: %0d", match_count);
        $display ("FRAMES MISMATCHED: %0d", error_count);
        $display ("FUNCTIONAL COVERAGE SCORE: %0.2f%%", uart_cg.get_coverage());
        
        
        if (error_count ==0 && items_pushed>0) $display ("STATUS: TEST PASSED");
        else $display ("STATUS: TEST FAILED");
       
         
    endfunction 
    
    
endclass
