`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: uart_top
// Description: Top-level Full-Duplex UART system combining the Baud Generator,
//              Transmitter, and Receiver blocks.
//////////////////////////////////////////////////////////////////////////////////

module uart_top (
    input  logic       clk,
    input  logic       reset_n,

    // TX Parallel Interface
    input  logic       tx_valid,
    input  logic [7:0] tx_hold_register,
    
    // RX Parallel Interface
    output logic [7:0] rx_hold_register,
    output logic       rx_valid,

    // Flow Control Ports
    input  logic       tx_cts_n,
    output logic       tx_rts_n,
    input  logic       rx_rts_n,
    output logic       rx_cts_n,

    // Physical Serial Pins
    output logic       uart_tx_pin, // Serial Line out
    input  logic       uart_rx_pin  // Serial Line in
);

    // Shared internal oversampling tick wire
    logic bclk_pulse;

    // 1. Instantiate the Common Baud Rate Generator
    mod_gen baud_generator (
        .clk        (clk),
        .reset_n    (reset_n),
        .bpulse (bclk_pulse) // 16x oversampling clock pulse
    );

    // 2. Instantiate the Transmitter Block
    uart_tx_fin transmitter (
        .clk              (clk),
        .reset_n          (reset_n),
        .cts_n            (tx_cts_n),
        .rts_n            (tx_rts_n),
        .tx_valid         (tx_valid),
        .tx_hold_register (tx_hold_register),
        .tx_data          (uart_tx_pin), // Drives physical serial TX pin
        .rx_data          (1'b1),        // Unused loopback tie-off
        .bclk_pulse       (bclk_pulse)
    );

    // 3. Instantiate the Receiver Block
    uart_rx_fin receiver (
        .clk              (clk),
        .reset_n          (reset_n),
        .rts_n            (rx_rts_n),
        .cts_n            (rx_cts_n),
        .rx_valid         (rx_valid),          // Output data valid pulse
        .rx_data          (uart_rx_pin),       // Listens to physical serial RX pin
        .rx_hold_register (rx_hold_register), // Outputs parallel byte data
        .bclk_pulse       (bclk_pulse)
    );

endmodule
