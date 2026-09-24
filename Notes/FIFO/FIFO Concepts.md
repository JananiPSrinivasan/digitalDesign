<!-- toc -->
## 1. What is a FIFO?

FIFO (First-In First-Out) is a hardware queue.

-   First data written is the first data read.
-   Supports temporary storage between producer and consumer.
-   Preserves ordering.
-   Uses circular memory.

Think of it as a **ring buffer**.

``` text
          +-------------------------+
Write --->|                         |----> Read
           |     Circular Memory    |
           |                         |
          +-------------------------+
```

------------------------------------------------------------------------

## 2. Major Building Blocks

Every FIFO consists of only a few logical blocks.

``` text
            +-----------------+
            | Write Control   |
            +-----------------+
                    |
                    v
             +-------------+
             |   Memory    |
             +-------------+
                    ^
                    |
            +-----------------+
            | Read Control    |
            +-----------------+
```

Everything else is supporting logic.

------------------------------------------------------------------------

## 3. Information Every FIFO Maintains

Every FIFO always tracks:

-   Write pointer
-   Read pointer
-   Memory
-   Status flags

------------------------------------------------------------------------

## 4. Write Side Responsibilities

The write logic is responsible for:

-   Accepting incoming data
-   Determining where data is written
-   Advancing the write pointer
-   Detecting the FULL condition

``` text
Incoming data
      |
      v
Is FIFO full?
      |
      +-- No --> Write data
                 Increment pointer
```

------------------------------------------------------------------------

## 5. Read Side Responsibilities

The read logic is responsible for:

-   Supplying outgoing data
-   Determining which location to read
-   Advancing the read pointer
-   Detecting the EMPTY condition

``` text
Read request
      |
      v
Is FIFO empty?
      |
      +-- No --> Read data
                 Increment pointer
```

------------------------------------------------------------------------

## 6. Why Are Pointers Needed?

Pointers indicate:

-   Next write location
-   Next read location

Example:

``` text
Memory

0
1
2
3
4
5
6
7

Write pointer -> 5

Read pointer -> 2
```

------------------------------------------------------------------------

## 7. Circular Buffer Concept

Pointers wrap around.

``` text
0
1
2
3
4
5
6
7
 ^
 |
 +------ wrap back here
```

Instead of stopping:

``` text
7 + 1 = 0
```

------------------------------------------------------------------------

## 8. Why Use an Extra Pointer Bit?

Without an extra bit:

``` text
Read  = 000
Write = 000
```

This could mean either **EMPTY** or **FULL**.

An extra MSB tracks wrap-around.

``` text
Read  = 0 000
Write = 1 000
```

The address is the same, but the wrap bit differs.

------------------------------------------------------------------------

## 9. Memory Address vs Pointer

Pointer:

-   Address bits
-   One wrap bit

Memory uses **only the address bits**.

The wrap bit is used only for FULL/EMPTY detection.

------------------------------------------------------------------------

## 10. FIFO States

Conceptually, every FIFO has only three states:

-   Empty
-   Partially Full
-   Full

------------------------------------------------------------------------

## 11. FULL Detection

Concept:

The write pointer catches the read pointer **after completing one
additional wrap**.

The wrap bit distinguishes FULL from EMPTY.

------------------------------------------------------------------------

## 12. EMPTY Detection

Concept:

Read pointer equals write pointer.

No unread data remains.

------------------------------------------------------------------------

## 13. Simultaneous Read and Write

If both occur simultaneously:

-   One element leaves the FIFO.
-   One new element enters.
-   Occupancy remains unchanged.
-   Both pointers advance.

------------------------------------------------------------------------

## 14. Overflow

Occurs when a write is attempted while the FIFO is FULL.

Correct behavior:

-   Ignore the write, or
-   Raise an overflow flag/error.

Never overwrite unread data.

------------------------------------------------------------------------

## 15. Underflow

Occurs when a read is attempted while the FIFO is EMPTY.

Correct behavior:

-   Ignore the read, or
-   Raise an underflow flag/error.

Never return invalid data.

------------------------------------------------------------------------

## 16. Synchronous FIFO

Both sides use the same clock.

``` text
          clk

Write ---> FIFO ---> Read
```

Characteristics:

-   Single clock
-   No clock-domain crossing (CDC)
-   Binary pointers are sufficient
-   Easier timing closure

------------------------------------------------------------------------

## 17. Asynchronous FIFO

Write and read use different clocks.

``` text
Write Clock
      |
      v
     FIFO
      ^
      |
Read Clock
```

Example:

-   Write: 100 MHz
-   Read: 75 MHz

Pointers must safely cross clock domains.

------------------------------------------------------------------------

## 18. Why Clock Domain Crossing Matters

Binary counter transition:

``` text
0111
 ↓
1000
```

Multiple bits change simultaneously.

A receiving clock may sample an invalid intermediate value.

------------------------------------------------------------------------

## 19. Why Gray Code?

Gray code changes **only one bit** between adjacent values.

Binary:

``` text
000
001
010
011
100
```

Gray:

``` text
000
001
011
010
110
```

One-bit transitions greatly reduce CDC issues.

------------------------------------------------------------------------

## 20. Synchronizers

Pointers cross clock domains using a **2-flip-flop synchronizer**.

``` text
Pointer
  |
  v
 FF1
  |
  v
 FF2
  |
  v
Destination Logic
```

Purpose:

-   Reduce metastability probability.
-   Safely transfer Gray-coded pointers.

------------------------------------------------------------------------

## 21. Binary vs Gray Responsibilities

### Binary Pointer

-   Increment
-   Memory addressing

### Gray Pointer

-   Clock-domain crossing
-   FULL/EMPTY comparison

**Rule to remember:**

> Binary is for counting and addressing. Gray is for communication
> across clock domains.

------------------------------------------------------------------------

## 22. Pointer Flow in an Asynchronous FIFO

### Write Side

``` text
Binary Pointer
      |
      v
 Gray Pointer
      |
      v
Synchronizer
      |
      v
 Read Domain
```

### Read Side

``` text
Binary Pointer
      |
      v
 Gray Pointer
      |
      v
Synchronizer
      |
      v
Write Domain
```

------------------------------------------------------------------------

## 23. Questions to Ask Before Coding Any FIFO

### Memory

-   What is the FIFO depth?
-   What is the data width?
-   Is it synchronous or asynchronous?

### Pointer Design

-   How many address bits are needed?
-   Do I need an extra wrap bit?
-   How will pointers wrap?

### Write Logic

-   When does the write pointer increment?
-   What happens on write when FULL?

### Read Logic

-   When does the read pointer increment?
-   What happens on read when EMPTY?

### Status Flags

-   How is FULL detected?
-   How is EMPTY detected?
-   Are almost-full/almost-empty flags required?

### Clocking

-   One clock or two?
-   If two clocks:
    -   How are pointers synchronized?
    -   Where are synchronizers needed?
    -   Are Gray pointers used?

### Memory Interface

-   Which bits address memory?
-   Which bits track wrap-around?

------------------------------------------------------------------------

## 24. FIFO Design Checklist

Whenever asked to design a FIFO:

1.  Decide whether it is synchronous or asynchronous.
2.  Determine memory depth and data width.
3.  Size the pointers (address bits + wrap bit).
4.  Design the write path.
5.  Design the read path.
6.  Define FULL and EMPTY flag logic.
7.  For asynchronous FIFOs:
    -   Use Gray-coded pointers.
    -   Synchronize pointers with two flip-flop synchronizers.
8.  Remember the golden rule:

> **Binary pointers are for counting and memory addressing. Gray
> pointers are only for safely transferring pointer values across clock
> domains.**

------------------------------------------------------------------------

# FIFO Buffer Depth Calculation Notes

# Purpose

The FIFO depth determines how many data words can be stored before the
producer must stop writing or the consumer must begin reading.

Choosing the correct depth is one of the most important design decisions
because it directly affects:

-   Data loss
-   Latency
-   Area
-   Power
-   Throughput

------------------------------------------------------------------------

# What Does FIFO Depth Mean?

FIFO Depth = Number of storage locations inside the FIFO.

Example:

Depth = 16

The FIFO can store sixteen data words before becoming FULL.

------------------------------------------------------------------------

# FIFO Depth vs FIFO Width

These are independent.

-   Depth = Number of entries
-   Width = Number of bits per entry

Example:

Depth = 64 Width = 32 bits

Storage required

64 × 32 = 2048 bits

------------------------------------------------------------------------

# When Does FIFO Need More Depth?

Increase FIFO depth when:

-   Producer is faster than consumer
-   Consumer experiences stalls
-   Bursty traffic exists
-   Clock domains are asynchronous
-   DMA transfers occur in bursts
-   External memory has long latency

------------------------------------------------------------------------

# General Design Procedure

Ask these questions:

1.  What is the producer data rate?
2.  What is the consumer data rate?
3.  Can either side stall?
4.  What is the longest expected burst?
5.  What is the maximum service latency?
6.  What safety margin is required?

The answers determine the required depth.

------------------------------------------------------------------------

# Method 1: Burst Size

If a producer can generate a burst before the consumer starts reading:

FIFO Depth ≥ Maximum Burst Size

Example:

Producer writes 64 words continuously.

Consumer begins reading only after the burst ends.

Required depth

≥ 64 entries

------------------------------------------------------------------------

# Method 2: Latency

If the consumer is delayed:

FIFO Depth ≥ Producer Rate × Maximum Latency

Example

Producer rate = 100 words/µs

Consumer latency = 2 µs

Required depth

100 × 2 = 200 entries

------------------------------------------------------------------------

# Method 3: Rate Difference

When producer and consumer run continuously:

Depth ≥ (Producer Rate − Consumer Rate) × Observation Time

Only applicable if the producer is faster.

Example

Producer = 120 MB/s

Consumer = 100 MB/s

Difference

20 MB/s

If imbalance lasts for 5 µs:

Required buffer

20 × 5 = 100 bytes

------------------------------------------------------------------------

# Method 4: Clock Domain Crossing

Asynchronous FIFOs absorb phase differences between clocks.

Typical guidelines:

-   Small CDC: 8--16 entries
-   Moderate buffering: 16--64 entries
-   Large burst buffering: 64--512 entries
-   High-speed networking: hundreds or thousands of entries

Exact depth depends on traffic and latency.

------------------------------------------------------------------------

# Method 5: DMA or Memory Systems

If memory returns data after a fixed latency:

FIFO Depth ≥ Bandwidth × Memory Latency

Example

Bandwidth = 8 GB/s

Latency = 80 ns

Required storage

8 × 10\^9 × 80 × 10\^-9

= 640 bytes

------------------------------------------------------------------------

# Power-of-Two Rule

Most hardware FIFOs use depths that are powers of two.

Examples

-   8
-   16
-   32
-   64
-   128
-   256
-   512

Reasons:

-   Simpler addressing
-   Easy pointer wrap-around
-   Efficient hardware implementation

------------------------------------------------------------------------

# Trade-Offs

Small FIFO

Advantages

-   Low area
-   Low power

Disadvantages

-   More overflow risk
-   Less tolerance to bursts

Large FIFO

Advantages

-   Better burst handling
-   Better latency tolerance

Disadvantages

-   Higher area
-   Higher power
-   Increased latency

------------------------------------------------------------------------

# Occupancy

Occupancy = Number of valid entries currently stored.

Rules

Occupancy = 0

FIFO is EMPTY

Occupancy = Depth

FIFO is FULL

Occupancy changes by:

-   +1 on successful write
-   -1 on successful read
-   0 on simultaneous read/write

------------------------------------------------------------------------

# Choosing a Safety Margin

Real systems rarely size FIFOs exactly at the theoretical minimum.

Typical practice:

Required Depth = Calculated Depth × Safety Factor

Safety factor is often between 1.2 and 2 depending on application.

------------------------------------------------------------------------

# Typical FIFO Depths

  Application    Typical Depth
  -------------- -----------------------
  UART           8--64
  SPI            8--32
  Audio          64--512
  Video          Hundreds to thousands
  Ethernet       Hundreds to thousands
  AXI DMA        32--1024
  CPU Pipeline   4--32
  DSP            16--256

------------------------------------------------------------------------

# FIFO Depth Design Checklist

Before selecting a FIFO depth, ask:

-   What is the producer rate?
-   What is the consumer rate?
-   Are clocks synchronous or asynchronous?
-   What is the maximum burst size?
-   What is the maximum consumer latency?
-   Is backpressure available?
-   What overflow probability is acceptable?
-   Is power or area constrained?
-   Is future scalability required?

------------------------------------------------------------------------

# Key Rules to Remember

1.  Depth is determined by buffering requirements, not memory size
    alone.
2.  Bursts require deeper FIFOs.
3.  Latency requires deeper FIFOs.
4.  Asynchronous systems usually need larger FIFOs.
5.  Choose power-of-two depths whenever possible.
6.  Always include engineering safety margin.
7.  Verify the design under worst-case traffic conditions.
