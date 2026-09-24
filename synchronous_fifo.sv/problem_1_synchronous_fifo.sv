// Refer [[Notes/FIFO]]


module fifo_buffer #(
	parameter int N = 32
	parameter int DEPTH= $clog2(N), //synthesizable only when passed as parameters, constants or expressions made out of parameters 
	parameter bit WIDTH=N
	parameter int ALMOST_FULL_THRESH = DEPTH-1,
	parameter int ALMOST_EMPTY_THRESH = 0
)(
	input logic clk,
	input logic rst_n,
	
	input logic write_en,
	input logic [WIDTH-1:0] write_data,

	input logic read_en,
	input logic [WIDTH-1:0] read_data

	// flags
	input bit almost_empty = 1,
	input bit almost_full = 1,
	input bit empty = 1,
	input bit full = 1
);


// Check for Width and Depth if they are in power of 2

Static_Check_DEPTH: assert property (@(posedge clk) (DEPTH >0)&&((DEPTH &(DEPTH-1) ==0)))
	else $error ("DEPTH not in Powers of 2");
Static_Check_WIDTH: assert property (@(posedge clk) (WIDTH > 0) && (WIDTH &(WIDTH-1)==0)))
	else $error ("WIDTH Not in Powers of 2");

// Initialise FIFO memory, address, counter and pointers to the address.
parameter int [DEPTH-1:0] memory [WIDTH-1:0]






//Reset behaviour 
always @(posedge clk) begin 
	if (!reset_n) begin 
		read_ptr <= 0;
		write_ptr <= 0;
		counter <= 0;
		almost_full <= 0;
		almost_empty <= 1;
	end
end

// Write operation

always @(posedge clk) begin 
	if (write_en && !full) begin 
		write_ptr <= write_data;
		write_ptr <= write_ptr+1;
	end
end

// Read operation

always @(posedge clk) begin 
	if (read_en && !empty) begin 
		read_data <= read_ptr;
		read_ptr <= read_ptr+1;
	end
end

endmodule