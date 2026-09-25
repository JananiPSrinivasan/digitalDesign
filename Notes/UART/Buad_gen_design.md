
Designing a simple baud gen in system verilog.

1. Parameterise the baud_rate, raw_uart_frequency 
2. use mode_sel to choose between 13x and 16x
3. use a simple down modulo counter to count upto divisor

```
module baud_gen #(
	parameter int BAUD_RATE = 9600,
	parameter int RAW_UART_FREQUENCY = 150000000,
	parameter int OVERSAMPLING_FREQ = 16
	)(
	input logic clk,
	input logic reset_n,
	output logic bclk
);

//declare registers to store the divisors
logic [15:0] DL; // Divisor Latch MSBs

assign DL = RAW_UART_FREQUENCY / (BAUD_RATE * OVERSAMPLING_FREQ);





endmodule
```



Iteration 1: 
```

// register to hold oversampling factor

logic [5:0] oversampling_factor_reg;

// Use combo logic to oversampling factor based on mode

always_comb begin 
	 oversampling_factor_reg = (mode_sel == 1'b1 ? 5'd16 : 5'd13);
end

// calculate internal clock based on baud rate and oversampling factor

logic []

```
issue: 

oversampling factor is stored in registers and is done in run time whereas my baudrate is in compile time. We cannot compute a compile time with a runtime

