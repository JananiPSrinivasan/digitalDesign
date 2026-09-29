/* UART RX 
The main difference between an UART TX and an RX is the start and stop Bit
in a TX, the Start and stop bits are driven.
in a RX, the Start and stop bits are detected.

So the states become IDLE, START, RECIVE, STOP

*/

module uart_rx_fin(
	input logic clk, 
	input logic bclk,
	input logic reset_n,
	
	input logic tx_data,
	output logic rx_data,
	
	input logic bclk_pulse,
	
//	input logic [7:0] Reciever_hold_reg,
	
	input logic cts_n,
	input logic rts_n
); 
endmodule

