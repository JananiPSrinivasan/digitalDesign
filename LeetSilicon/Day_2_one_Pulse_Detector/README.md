## Problem Statement
Design RTL to assert an output when the input is high for exactly one clock cycle.

## Requirements
### INPUTS: clk, rst_n (optional), sig_in.
### OUTPUT: onecycle_pulse.
### HISTORY: Keep 2-cycle history using two registers.
### DETECT: Assert onecycle_pulse for 1 cycle when pattern 0,1,0 is observed in consecutive samples.

## Test Cases

#### Test Case 1 :
Valid: ...0,1,0... triggers onecycle_pulse once.
#### Test Case 2 :
 Two-cycle high: ...0,1,1,0... does not trigger.
#### Test Case 3 :
 Stuck high: ...1,1,1... does not trigger. 