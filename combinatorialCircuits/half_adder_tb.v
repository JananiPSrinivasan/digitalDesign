`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2025 12:27:14 PM
// Design Name: 
// Module Name: half_adder_testbench
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

module half_adder_seq_testbench();
    reg X, Y;
    wire S, C;
    
    half_adder_seq uut(
        .A(X),
        .B(Y),
        .Sum(S),
        .Carry(C)    
    );
    
    initial begin
        
        $display("Time\tX\tY\tS\tC");
        $monitor ("0%d\t%b\t%b\t%b\t%b",$time, X, Y, S, C);
        
        X=0;Y=0;#10;
        X=0;Y=1;#10;
        X=1;Y=0;#10;
        X=1;Y=1;#10;
        
        $finish;
        
        
        end
        




endmodule
