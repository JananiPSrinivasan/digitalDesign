### Problem Statement
Design a configurable FIFO buffer to handle streaming data from a high-speed sensor module to a slower processor interface. The FIFO must prevent data loss while ensuring efficient throughput.

The sensor sends 8-bit data at 50 MHz, while the processor reads data at 25 MHz, with occasional stalls (reads only 80% of the time). Your task is to:

- Calculate the minimum FIFO depth required to prevent overflow during processor stalls.
- Design a Finite State Machine (FSM) to control the FIFO read/write interface.
- Include full/empty detection, programmable thresholds, and overflow/underflow flags.
- Verify the FIFO functionality using a testbench that models the sensor and processor behavior.

## Specification 
### FIFO Depth Calculation

#### Inputs
- Write clock: 50 MHz (20 ns period)
- Read clock: 25 MHz (40 ns period)
- Read enable active only 80% of the time
- Simulation duration: 10 µs (optional cap for verification)

#### Goal:
- Calculate the minimum FIFO depth (D) such that:
- No data is lost even when the processor stalls up to 20% of the time.
- Assume constant data generation from the sensor.

