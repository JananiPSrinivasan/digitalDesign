`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2025 05:05:31 PM
// Design Name: 
// Module Name: Subtractor
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


module Subtractor(
    output reg Borrow,
    output reg Difference,
    input A,
    input B

    );
    
    always @(*)
    
        begin
          
          Difference = A ^ B;
          Borrow = ~A & B;
            
        end
            
endmodule
