## Problem Statement
Design synchronous RTL that detects low→high, high→low, and any toggle of a 1-bit input using a delayed sample and compares.

## Requirements
### INPUTS: clk, rst_n (optional), sig_in.
### OUTPUTS: rise_pulse, fall_pulse, toggle_pulse.
#### REGISTER: Capture previous value of sig_in each cycle.
#### TOGGLE: toggle_pulse asserts for 1 cycle when sig_in != sig_prev.
#### RISING: rise_pulse asserts for 1 cycle when sig_in=1 and sig_prev=0.
#### FALLING: fall_pulse asserts for 1 cycle when sig_in=0 and sig_prev=1.

## Test Cases
### Test Case 1 :
 Rising: 0→1 transition produces rise_pulse=1 for one cycle.
### Test Case 2 :
 Falling: 1→0 transition produces fall_pulse=1 for one cycle.
### Test Case 3 : 
 No Toggle: constant input produces no pulses.