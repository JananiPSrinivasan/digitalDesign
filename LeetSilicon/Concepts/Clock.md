# Clock

- Basic fundamental block that allows all the blocks to be synchronous 

   ┌───┐     ┌───┐     ┌───┐
___│   │_____│   │_____│   │____
   ↑         ↑         ↑
 posedge   posedge   posedge

- Its like the hearbeat for the entire system
- Think of clock like:
    - A camera taking snapshots.
    - Combinational logic = moving objects
    - Clock edge = camera shutter
    - It captures whatever is visible at that instant.

## Properties

### Period (T)

Time for one full cycle.

    T = 1/f

Example:
100 MHz → T = 10 ns

### Frequency (f)

How many cycles per second

    f= 1/T

### Duty Cycle 

Percentage of time for which the Clock is HIGH
Ideal clocks are 50% HIGH and 50% LOW

### Some frequency asked Period an Frequency

| Frequency | Period |
| --------- | ------ |
| 1 GHz     | 1 ns   |
| 500 MHz   | 2 ns   |
| 250 MHz   | 4 ns   |
| 100 MHz   | 10 ns  |
| 50 MHz    | 20 ns  |
| 10 MHz    | 100 ns |

## What Happens on a Clock Edge ?

``` 
always_ff @(posedge clk)
    q <= d;

assign qbar = ~q;
```

- whnever there is a pos_edge, the value of d is updated to q
- q stores the value till the next update comes in
- Update happens at the end of timestep due to NBA

## What happens between two clock edges?

- Registers hold constant values.
- Combinational logic computes using those values.
- Outputs of combinational logic may change many times.
- But registers do NOT change.

### Some Questions to Test Understanding :

1. If d toggles 10 times between two clock edges, how many times can q change?

- q changes 0 times
- 'Between' two clock eges, q does not change
- q updates only for the clock
    - Not before
    - Not after
    - Not inbetween

2. If you have two registers:
```
always_ff @(posedge clk)
    q1 <= d1;

always_ff @(posedge clk)
    q2 <= d2;
```
Do they update one after the other or at the same time?

- Yes

3. If one register uses posedge clk and another uses negedge clk, are they still synchronous

- Yes, they are in the same clock domain but they are not edge-aligned 

4. If clock frequency is 100 MHz, What is the time difference between posedge and negedge? (assume 50% duty cycle)

f = 100Mhz
t = 10ns
time inbetween = t/2 = 5ns

5. If clock frequency is 100 MHz, What is the time difference between posedge and negedge? (assume 60% HIGH and 40% LOW)

f= 100Mhz
t = 10ns
t-high = 0.6 x 10ns = 6ns
t-low = 0.4 x 10 = 4ns
