`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Janani P Srinivasan
// 
// Create Date: 03/03/2025 02:44:26 PM
// Design Name: 
// Module Name: full_adder
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
module full_adder_tb();
    
    reg X, Y, Cin;
    wire S, C;
    
    full_adder uut(
        .A(X),
        .B(Y),
        .Cin(Cin),
        .Sum(S),
        .Carry(C)
    );
    
    initial begin
        
        X=0;Y=0;Cin=0;#50;
        X=0;Y=0;Cin=1;#50;
        X=0;Y=1;Cin=0;#50;
        X=0;Y=1;Cin=1;#50;
        X=1;Y=0;Cin=0;#50;
        X=1;Y=0;Cin=1;#50;
        X=1;Y=1;Cin=0;#50;
        X=1;Y=1;Cin=1;#50;
        $finish;
        
       end

    
endmodule 