`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Janani P Srinivasan
// 
// Create Date: 03/03/2025 12:24:33 PM
// Design Name: Basic_Designs
// Module Name: half_adder
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


module half_adder(Sum, Carry, A,B
    );
    input A, B;
    output Sum, Carry;
    assign Sum= A^B;
    assign Carry = A & B;
endmodule
