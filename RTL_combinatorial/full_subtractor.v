`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2025 12:21:38 PM
// Design Name: 
// Module Name: full_subtractor
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


module full_subtractor( 
   
    input  A,
    input  B,
    input Bin,
    output reg Borrow,
    output reg Difference

    );
    
    always @(*)
   
    begin
        
        Difference = A^B^Bin;
        Borrow = (~A & B) | (~(A^B) & Bin);
     end
 
endmodule
