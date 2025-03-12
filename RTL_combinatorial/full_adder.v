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


module full_adder( 
    output reg Carry,
    output reg Sum,
    input A, 
    input B, 
    input Cin

    );
    
    
    
    reg Sum1, Carry1, Carry2;
    
    always @ (*) begin
    
        Sum1 = A ^ B;
        Carry1 = A & B;
        Sum = Sum1 ^ Cin;
        Carry2 = Sum1 & Cin;
        Carry = Carry1 | Carry2;
        
        end
         
endmodule
