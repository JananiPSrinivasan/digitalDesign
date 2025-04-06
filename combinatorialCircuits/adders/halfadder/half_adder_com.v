`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2025 01:00:17 PM
// Design Name: 
// Module Name: half_adder_com
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


module half_adder_seq( 
    output reg Sum,
    output reg Carry,
    input A,
    input B
    );
    
    always @ (*)
        begin
           Sum = A^B;
           Carry = A & B;
        end
endmodule
