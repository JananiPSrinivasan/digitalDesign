interface uart_if;
    logic clk;
    logic reset_n;
    logic bclk_pulse;

    logic [7:0] tx_hold_register;
    logic tx_valid;
    logic tx_data;
    logic rx_data;

    logic cts_n;
    logic rts_n;

    modport tx(
        input clk,
        input reset_n,
        input bclk_pulse,

        input tx_valid,
        input tx_hold_register,
        input cts_n,
 
        output tx_data

    );

    modport brg(
        input clk,
        input reset_n,
        output bclk_pulse
    );


    
endinterface