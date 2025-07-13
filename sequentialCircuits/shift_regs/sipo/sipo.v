module sipo (
    input serial_data_in,
    input clk,
    input rst_n,
    output reg [3:0] q
);

    always@(posedge clk) begin
        if (!rst_n)
            q <= 4b'0000;
        else
            q<= {[2:0],serial_data_in};
    end

endmodule