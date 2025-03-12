`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 12:09:11 PM
// Design Name: 
// Module Name: half_subtractor_tb
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


module half_subtractor_tb();

    reg X,Y;
    wire B, D;
    
    Subtractor uut(
        .A(X),
        .B(Y),
        .Borrow(B),
        .Difference(D)
    );
    
    initial begin
        
        X=0;Y=0;#10;
        X=0;Y=1;#10;
        X=1;Y=0;#10;
        X=1;Y=1;#10;
        $finish;
    end
    
endmodule
