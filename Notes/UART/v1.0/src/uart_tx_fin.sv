/*2. Tx state machine

Configuration
	Clock = 150Mhz
	Baud rate = 9600,
	Oversampling mode 16,
	
	Start bit = 1,
	Data bits = 8,
	Parity = N
	Stop bit = 1

Working Logic of the code: 

	// When the clock starts, 
		// The baud rate calculated from the firmware is dumped into the DL registers through AHB
		// The DL registers start the bclk_counter to trigger the bclk pulse
		// The data is held in tx_hold_register, bclk is triggered
		
			// When a transmission starts:
				// Snap ALL 8 bits from tx_hold_register into the shift_register at once.
				// Pre-transmit a 0 (Start bit) for 16 bclk pulses.
				
			// Start a counter to transmit each bit for 16 cycles:
					For every 16 cycles, pull the next data bit OUT of the shift register.
					This data bit is exposed to the TX pin by right shifting the register down.
					Once 16 cycles pass, reset this counter to 0.
					
			// Now, use an up counter to track the number of bits going out total of 8 bits 
				// Once 8 bits are detected, transmit a 1 (Stop bit) for 16 bclk pulses.
				// Reset the bit_counter to 0
				
		// The bclk_counter is decremented (this is irrespective of the data inside. for every total cycles calculated, this when hits zero, resets)
		// Once bclk_counter reaches zero, bclk sends a pulse
		
Mental Mapping of components:

counters : 
	- 1xUpcounter for counting 8 bits (3 bits)
	- 1xDowncounter for counting 16 cycles (4 bits)
shift register :
	- 1x PISO 
	
How to construct this? 

We can see that the inputs depend on history and time. so we need state machines
how many states? 
1. IDLE -  no transaction happens
		   all counters reset to zero
2. START - begining of a transaction, 
		   the start bit is loaded in the shift reg
3. TRANSMIT - shift bits 0 to 7.
			- increment/ decrement counters.
			- send data out of tx pin
4. STOP - the transaction comes to an end if the stop bit is detected
 
	
*/	

module uart_tx(
    input logic clk,
    input logic reset_n,
    // control signals
	input logic cts_n, // clear to send
	output logic rts_n, // request to send
	input logic tx_valid,
	
	// Data reieved in parallel has to be transmitted serially
	input logic [7:0]tx_hold_register, // 8 bit hold register, the data is held here
	output logic tx_data, // serial output
	
	// Data reieved in serially
	input logic rx_data,
	
	// The bclk out from the baud gen is fed as input pulse here
	input logic bclk_pulse
	
    
); 
	// declare counter registers
	logic [3:0] cycle_counter, next_cycle_counter;
	logic [2:0] bit_counter, next_bit_counter;
	
	
	// temporary shift reg
	logic [7:0] temp_piso = 8'd0;
	logic [7:0] next_piso;
	

	
	// user defined enum datatype
	typedef enum logic [2:0] {
		IDLE = 3'b000,
		START = 3'b001,
		TRANSMIT = 3'b010,
		STOP = 3'b011
	}state_t;
	
	// State variables from state_t
	
	state_t curr_state, next_state;
	
	// sequential logic to update curr_state
	
	always_ff @(posedge clk) begin 
		if (!reset_n) begin 
			curr_state <= IDLE;
			temp_piso <= 8'd0;
			cycle_counter <= 4'd0;
			bit_counter <= 3'd0;
		end 
		else begin
			curr_state <= next_state;
			temp_piso <= next_piso; // value to be shifted should be dumped here
			cycle_counter <=  next_cycle_counter;
			bit_counter <= next_bit_counter;
		end
	end

	// combo logic for next state;
	
	always_comb begin 
		next_state = curr_state;
		next_piso = temp_piso;
		next_bit_counter = bit_counter;
		next_cycle_counter = cycle_counter;
		
		
		case(curr_state) 
			IDLE:begin 
			
				next_bit_counter = 3'd0;
				next_cycle_counter = 4'd0;
				if (!cts_n && tx_valid) begin 
					next_piso = tx_hold_register;
					next_state = START; 
				end else next_state = IDLE;
			//end
			end
			START:begin
			    if (bclk_pulse) begin 
					if (cycle_counter == 4'd15) begin 
						next_cycle_counter = 4'd0;
						next_state = TRANSMIT;
					end else next_cycle_counter = cycle_counter + 1'd1;
				end 			
			end
			TRANSMIT: begin
				if (bclk_pulse) begin 
					if (cycle_counter ==4'd15) begin 
						next_cycle_counter = 4'd0;
						if (bit_counter == 3'd7) begin 
							next_state = STOP;
							next_bit_counter = 3'd0;
						end else begin 
							next_piso = temp_piso >> 1;
							next_bit_counter = bit_counter + 1'd1; 
						end
					end else next_cycle_counter = cycle_counter + 1'd1;
				end
			
				
			end
			STOP: begin 
				if (bclk_pulse)begin 
					if (cycle_counter == 4'd15) begin 
						next_cycle_counter = 4'd0;
						next_state = IDLE;
					end else begin 
						next_cycle_counter = cycle_counter + 1'd1;
					end
					
				end
			end
			default : next_state = IDLE;
		endcase
	end
	
	// Output combo logic
	
	always_comb begin 
		case(curr_state) 
			IDLE: tx_data = 1'b1;
			START: tx_data = 1'b0;
			TRANSMIT: tx_data = temp_piso [0];
			STOP:tx_data = 1'b1;
			default: tx_data = 1'b1;
		endcase
		rts_n = 1'b1;
	end
	
	
endmodule