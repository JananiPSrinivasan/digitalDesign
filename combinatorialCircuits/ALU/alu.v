`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Janani P Srinivasan
// 
// Create Date: 05/27/2025 01:53:26 PM
// Design Name: 
// Module Name: ALU
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


module (
    output reg [7:0] z,
    output reg carryout,
    output reg invalid_op,
    output reg borrow,
    output zero,
    output parity,
    input [7:0] A,
    input [7:0] B,
    input [3:0] opcode,
    input carryin
)

localparam OP_ADD = 1;
localparam OP_ADD_CARRY=2;
localparam OP_SUB = 3;
localparam OP_INC = 4;
localparam OP_DEC = 5;
localparam OP_AND = 6;
localparam OP_NOT = 7;
localparam OP_ROL = 8;
localparam OP_ROR = 9;

always @ (*)
    begin
        z=0;
        carryout =0;
        invalid_op=0;
        case (opcode)
            OP_ADD:
            begin
                z=a+b;
            end
            OP_ADD_CARRY: 
            begin
                {carryout, z} = a+b+carryin; 
            end
            OP_SUB:
            begin {borrow,z}= a-b ; end

            OP_INC:
            begin {carryout,z} = a+ 1b'1; end

            OP_DEC:
            begin {borrow,z} = a - 1b'1; end

            OP_AND:
            begin z = a & b; end

            OP_NOT:
            begin z = ~a; end

            OP_ROL :
            begin y = {a[5:0], a[6]} ;end

            OP_ROR:
            begin y= {a[0],a[6:1]};end
            default: begin invalid_op=1;end

        endcase
    end

    assign parity=^y;
    assign zero = (y==0);




endmodule
