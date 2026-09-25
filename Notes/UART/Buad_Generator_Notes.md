**What is Baud Rate?**  

Baud rate measures the number of times the signal changes its state per second. That is, baud rate tells how long a signal is active, and both the transmitter and receiver must agree on this active period. The baud rate of the transmitter and receiver must remain the same so that the transaction happens without any data loss.

**Why do we need Baud Rate?**  

Usually, the processor operates at a very high clock frequency. This speed cannot be matched by serial protocols at the peripherals, as physical copper wires cannot change states millions of times per second cleanly.

We need to step down this speed for our communication interface. 

To do that, we build a dedicated hardware counter inside the UART peripheral that deliberately lets a ==specific number of raw clock cycles pass== by before triggering a action, bridging the speed gap between a high-speed system clock and a low-speed protocol.

**How does the hardware know how many cycles to let pass?**  
This is where we use the Baud rate. The target baud rate is multiplied by an oversampling factor to calculate the required internal sampling clock of the protocol:

```
Internal_Sampling_Clock = Baud_Rate * oversampling_factor
```

```
Divisor(Number of Cycles) = System_Clock / Internal_Sampling_Clock
```

This divisor tells the internal hardware counter exactly how many system clock cycles to count down before firing a single oversampling tick.


**What is oversampling factor and why do we need it?**

Ideally, we cannot just sample a UART line at exactly 1 bit per interval (1x sampling). Because asynchronous serial communication lacks a shared clock wire, the receiver has no idea when a bit begins or ends. 

If the receiver's clock drifts even slightly, or if there is electrical noise at the bit edges, **data gets corrupted or lost.**

To solve this, we use an **Oversampling Factor** (typically 13x or 16x).

The **Sampling Factor** dictates how many times the internal hardware clock will tick during the span of exactly one incoming data bit. 

If the user chooses **16x mode**, the duration of a single bit is mapped across a **16-cycle internal clock window**.

**How this works in an SOC?**

1. **Clock Source Generation:** A physical **Crystal Oscillator** on the board generates a base reference clock. The SoC’s internal **PLL (Phase-Locked Loop)** multiplies this frequency up to create a high-speed, stable internal system and peripheral clock.

2. **Clock Routing:** This boosted peripheral clock is fed directly into the UART block's clock domain to act as the raw input heartbeat for the baud rate generator.

3. **Firmware Initialization (C Code):** The user defines the target baud rate in software. The **C firmware** executes an algebraic scaling equation using the current peripheral clock frequency to calculate the required integer divisor.

4. **Bus Transaction:** The CPU core executes a write command, driving the calculated divisor value across the high-performance **AMBA AHB Bus Interface** into a designated 16-bit or 32-bit memory-mapped configuration register inside the UART.

5. **Baud Rate Generation (SystemVerilog):** Once the hardware register latches the divisor value, an internal **Modulo Counter** running on the peripheral clock continuously cycles up or down to that target value. Every time the counter completes a cycle, it fires a single-cycle oversampling clock strobe (the baud tick).
    
6. **Architecture Division:** In this SoC architecture, the **SystemVerilog RTL** defines the physical AHB bus slave logic, configuration registers, and counting engines, while the **C Firmware** provides runtime control by dynamically computing and injecting register settings over the bus.



```
module buad_gen(); 




endmodule

```