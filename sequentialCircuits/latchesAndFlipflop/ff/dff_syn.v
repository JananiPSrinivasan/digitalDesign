module dff_syn(
    input wire clk,
    input wire rst,
    input d,
    output reg q,
    output wire qbar
);

always @(posedge clk) begin
    if (!rst)
        q <= 1'b0;
    else 
        q <= d;    
end
assign qbar = ~q;
endmodule
