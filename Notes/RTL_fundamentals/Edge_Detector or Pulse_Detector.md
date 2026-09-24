## Question types

1. You are verifying a hardware block that receives a signal called pkt_valid from an upstream module. pkt_valid may stay high for multiple cycles when a packet is being transferred. The downstream logic must increment a counter exactly once per packet, regardless of how long pkt_valid stays high. The counter must not increment again until the current packet is fully completed and a new packet starts. **( Positive Edge detector with handshake)**
2. Design synchronous RTL that detects transitions on a 1-bit input signal `sig_in` and produces one single-cycle pulse output. A pulse is a single-cycle high (1 followed immediately by 0). `rise_pulse` fires one cycle after a 0→1 transition. When `rst_n` is asserted low, `sig_in` should be treated as 0. **(Pulse  Detector)**
3. Design synchronous RTL that detects transitions on a 1-bit input signal `sig_in` and produces one single-cycle pulse outputs. `fall_pulse` fires one cycle after a 1→0 transition. When `rst_n` is asserted low, `sig_in` should be treated as 0. **(Neg Pulse Detector)**
4.  Design synchronous RTL that detects transitions on a 1-bit input signal `sig_in` and produces one single-cycle pulse outputs. `toggle_pulse` fires one cycle after any change in either direction. When `rst_n` is asserted low, `sig_in` should be treated as 0. **(Toggle Detector)**
5. Assert output when input is high for exactly one clock cycle (pattern 0,1,0 in consecutive samples). **(Toggle Detection)**


## Logic to solve Edge Detector questions

#### How to detect transition? 
 - The signal transistions between 0->1->0 or 0->1->1
 - we can use a xor logic to identify this transition
 - xor works on 
		- 00 - 0
		- 11 - 0
		- 01/10 -1
~~- For a postive edge, we can detect~~ 
		~~- 0->1 counter ++~~
	~~- For a negative edge we can detect~~ 
		~~- 1->0, counter ++~~
	
 do we do this on the clock?
		- no, we do not do this on the clock, 
		- We use the signals only. 
But we have only one signal, how do we do xor with that?
		- We delay the signal 
		- Xor the original signal and delayed signal
	example : 0010
	delayed sample will be 0010

		0010
		  0010
  
	We see that 01, so we get the xor output as 1 	posedge. Again, the edge direction is not detected here, even if its a 1 to 0 the output is going to be 1

But this is good enough to see if we have a toggling pulse

####  How to detect the direction of change?

- eg
	 0010           1101
	    1101           0010
- WE can use an and gate between the current and delayed input.
- But in that case, wont everything be 0?
- So we can use a inverted input
- for a positive edge
	- 0->1 of the original signal is retained
	- this zero should turn 1 in the delayed signal, so 
	- Invert the delayed signal
- For a negative edge
	- 1-> 0 , if we retain the original signal and invert the delay,
		- The 0 falls under 0 and AND between two zeros is a zero
	- So invert the original signal
		- retain the delayed signal
	 0->1
		- one and one gives one on the output
		- so the direction is detected

#### How do we delay the signal ?

- Use a flipflop to delay. 
- Is it the only way?
	- No, but its the safest way
	- Why is it the safest way?
		- Flip flop delays it based on clock edge
		- Its realistic, deterministic and repeatable
##### How to answer this in interview standpoint
We delay the signal by one clock cycle using a flip-flop because it samples the input synchronously on the clock edge, giving a deterministic previous value that can be safely compared with the current value. Combinational delays are implementation-dependent and are not suitable for RTL edge detection

##### What are the other ways to do clock edge?
We can use a shift register to do this


## Interview notes

1. We need to detect a transition on a synchronous signal and generate a pulse that is high for exactly one clock cycle.
2. To detect an edge, I need to compare the current value of the signal with its value from the previous clock cycle
3. for the previous value, I'll register the input using a flip-flop. The registered value represents the previous sample.
4. Why compare with the previous sample?"
		An edge is defined by a change over time. A single sample only tells me the current value. By storing the previous sample, I can determine whether the signal changed and in which direction.
5. why not xor with clock?
		The clock is only the sampling event. I'm interested in whether the **signal** changed between two clock edges, so I compare the current sampled value with the previous sampled value. XORing with the clock would simply reflect the clock transitions, not the signal's transitions.
6. Since this is synchronous logic, I'll sample the input on every clock edge. I'll store the previous value in a flip-flop. On each clock, I'll compare the current input with the previous sample. Based on that comparison, I can determine whether a rising edge, falling edge, or any transition occurred. The output is generated as a one-clock-cycle pulse. I'll also reset the stored previous value to 0 during reset, and I assume the input is already synchronized to this clock domain.   

## Code
```
module edge_togggle_detector(
	input logic clk,
	input logic reset_n,
	input signal_in,
	
	output logic rise_pulse, 
	output logic fall_pulse,
	output logic toggle_pulse,
	output logic onepulse

);

logic delay_in_1, delay_in_2;

always@ (posedge clk) begin 
	if (! reset_n) begin
		delay_in_1 <= 1'b0;
		delay_in_2 <= 1'b0;
	end
	else begin
		delay_in_1 <= signal_in;
		delay_in_2 <= delay_in_1;
	end
end

assign rise_pulse = signal_in & (~delay_in_1);
assign fall_pulse = ~signal_in & delay_in_1;
assign toggle_pulse = signal_in ^ delay_in_1;
assign onepulse = (~signal_in & delay_in_1 & ~delay_in_2 );


one_high_pulse: assert property @(posedge clk)
	disable iff (!reset_n)
	(if ~signal_in && delay_in_1 && ~delay_in_2 ) |-> onepulse
	
	

endmodule
```
