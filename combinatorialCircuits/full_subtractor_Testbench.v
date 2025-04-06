`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 01:27:16 PM
// Design Name: 
// Module Name: full_subtractor_Testbench
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


module full_subtractor_Testbench(      

    );
    
    reg X, Y, Bin;
    wire B, D;
    
    full_subtractor uut(
        .A(X),
        .B(Y),
        .Bin(Bin),
        .Borrow(B),
        .Difference(D)
    );
    
    initial begin
        
        X=0;Y=0;Bin=0;#50;
        X=0;Y=0;Bin=1;#50;
        X=0;Y=1;Bin=0;#50;
        X=0;Y=1;Bin=1;#50;
        X=1;Y=0;Bin=0;#50;
        X=1;Y=0;Bin=1;#50;
        X=1;Y=1;Bin=0;#50;
        X=1;Y=1;Bin=1;#50;
        $finish;
        
       end
endmodule
