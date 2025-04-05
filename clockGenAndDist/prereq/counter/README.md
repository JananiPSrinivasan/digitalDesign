# Understanding of Counters

A counter is a sequental logic that is used to keep track of clock signals.

## Why Counter is a pre-req for clock divider?

- A clock divider needs to keep track of the clock signals after which toggling should happen

## What did I Learn while designing this counter?

- A Synchronous counter and a Asynchronous counter
  - Synchronous counter uses a global clock ( ideal in industrial usage) and combinational logic to increment the count
  - Async counter uses one instantiating clock and the toggling is done by feedback mechanism of each flipflop   
- PARAMETER - a keyword that is used to define constants
- '#' when declaring a module is used to define a preprocessor directive
- Relationship between verilog module and the testbench
  - The testbench is the simulator that sends stimulus to the module designed
  - The testbench instantiated the module and drives the input to the modules ( that is why in testbenches inputs are usually reg and the output is a wire)
  - The module processes the testbench signals and produces output ( that is why the inputs here are wires and the output is a reg)
   
