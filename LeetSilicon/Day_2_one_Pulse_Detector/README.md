## Problem Statement
Design RTL to assert an output when the input is high for exactly one clock cycle.

## Requirements
### INPUTS : 
clk, rst_n (optional), sig_in.
### OUTPUT : 
onecycle_pulse.
### HISTORY: 
Keep 2-cycle history using two registers.
### DETECT: 
Assert onecycle_pulse for 1 cycle when pattern 0,1,0 is observed in consecutive samples.

## Test Cases

#### Test Case 1 :
Valid: ...0,1,0... triggers onecycle_pulse once.
#### Test Case 2 :
 Two-cycle high: ...0,1,1,0... does not trigger.
#### Test Case 3 :
 Stuck high: ...1,1,1... does not trigger. 

 ## Solution 

 ### Understanding the problem
The output onecuycle pulse should be high only once as soon as the input transitions from 0->1.

Unlike the regular edge detector, where the output gives a pulse whenever the input transitions, the output from this circuit should pulse only once.

### How to Solve the Problem ?

- First like the usual edge detector, delay the input signal and capture it on register D1
    - This signal captures the rising edge transition

- Now sample the D1 register output with a delay of one cycle and store it on register D2.
    - This retains the previous cycle output (ie D1)

- Assign output onecycle_pulse to be Inverse of the input signal and-ed with output of d1 and-ed with output of D2 inverse (0->1->0)

### What actually happens ?
posedge 0:
    input - 0;
    D1 - 0 ;
    D2 - 0 ;
posedge 1:
    Input - 0->1 (0 value is not updated to 1 here because of <= assignment)
    D1 - 0;
    D2 - 0;
negedge 1:
    Input - 1 -> 0 (1 value is not updated to 0 here because of <= assignment)
posedge 2:
    Input - 0 (1)
    D1 - 1;
    D2 - 0;
posedge 3 :
    D1 - 0;
    D2 - 0;

Output : 
posedge 1 : 1 & 1 & 1 =1
posedge 2 : 0 & 1 & 1 =0





