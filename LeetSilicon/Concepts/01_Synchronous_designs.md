# Synchronous Systems

A synchronous system is a digital system in which:
- All state changes happen only at specific clock edges.
- Nothing changes randomly.
- Nothing updates whenever it wants.
- Everything waits for the clock.

## The Core Structure

A synchronous system always follows this structure:
```
[ Registers ] → [ Combinational Logic ] → [ Registers ]
```
### How it works?
During the cycle:
- Registers hold constant values.
- Combinational logic uses those values.
- It computes the "next state".
At the clock edge:
- All registers capture their new inputs simultaneously.
- The system moves to the next state.
- Then the process repeats.

## Registers (Sequential Logic)
- Store state
- Update only on clock edge
- Controlled by clock

**Example:**
```
always_ff @(posedge clk)
    q <= d;
```
## Combinational Logic

- No memory
- Output depends only on current inputs
- Not clocked
**Example:**
```
assign d = a & b;
```