---
date: 2026-09-29
Custom_Environment: false
UVM: false
Cocotb: false
SystemC: false
Directed_Test: false
CRV: false
Formal: false
Combination_Test: false
---
# DESIGN 

| Design Name              | baud_gen.sv                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Design Overview          | Baud gen will load the contents from the divisor register to a divisor counter. the divisor counter should generate a pulse and send va the bclk_pulse for a single cycle every time the counter completes the states.                                                                                                                                                                  |
| Scope of testbench       | **In-Scope Features**<br>• Reset Behavior: Resets to initial state when reset is triggered<br>• Counting : Increments by one every clock cycle<br>• Wrap Around : When the Final state is met, it goes back to initial state<br>• Pulse Generation : when the Final State is encountered,a single pulse is triggered<br>• Pulse Validation: The Pulse is valid only for one clock cycle |
| Verification Strategy    | [x] Directed<br>[x] CRV<br>[ ] Formal                                                                                                                                                                                                                                                                                                                                                   |
| Verification Environment | [ ] UVM<br>[ ] Cocotb<br>[ ] SystemC<br>[ ] Custom<br>[x] None                                                                                                                                                                                                                                                                                                                          |
| Test_Status              | [x] Pending<br>[ ] In Progress<br>[ ] Completed                                                                                                                                                                                                                                                                                                                                         |

## TEST PLAN

| Test Name       | Test ID | Priority | Target Requirment | Pass/Fail Criteria | Observed result |
| --------------- | ------- | -------- | ----------------- | ------------------ | --------------- |
| Reset_Behaviour | 001     |          |                   |                    |                 |

## COVERAGE PLAN 

| Code Coverage Target | Functional Coverage Target |
| -------------------- | -------------------------- |
|                      |                            |




