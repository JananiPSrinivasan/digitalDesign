module uart_rx_fin(
    input logic clk,
    input logic reset_n,

    // control signals
    input logic rts_n,
    output logic cts_n,
    input logic rx_valid,

    // Data received serially
    input logic rx_data,

    // Received parallel data
    output logic [7:0] rx_hold_register,

    // bclk pulse from baud generator
    input logic bclk_pulse
);

    // Counter registers
    logic [3:0] cycle_counter, next_cycle_counter;
    logic [2:0] bit_counter, next_bit_counter;

    // Temporary SIPO register
    logic [7:0] temp_sipo;
    logic [7:0] next_sipo;

    // RX holding register
    logic [7:0] next_rx_hold_register;


    // State declaration
    typedef enum logic [2:0] {
        IDLE    = 3'b000,
        START   = 3'b001,
        RECEIVE = 3'b010,
        STOP    = 3'b011
    } state_t;

    state_t curr_state, next_state;


  
    // Sequential logic
 

    always_ff @(posedge clk) begin

        if (!reset_n) begin
            curr_state       <= IDLE;
            temp_sipo        <= 8'd0;
            cycle_counter    <= 4'd0;
            bit_counter      <= 3'd0;
            rx_hold_register <= 8'd0;
        end

        else begin
            curr_state       <= next_state;
            temp_sipo        <= next_sipo;
            cycle_counter    <= next_cycle_counter;
            bit_counter      <= next_bit_counter;
            rx_hold_register <= next_rx_hold_register;
        end

    end


    // =========================================================
    // Combinational next-state logic
    // =========================================================

    always_comb begin

        // Default assignments
        next_state            = curr_state;
        next_sipo             = temp_sipo;
        next_bit_counter      = bit_counter;
        next_cycle_counter    = cycle_counter;
        next_rx_hold_register = rx_hold_register;


        case (curr_state)

            // =================================================
            // IDLE
            // =================================================

            IDLE: begin

                next_bit_counter   = 3'd0;
                next_cycle_counter = 4'd0;

                // RX line going LOW indicates a possible
                // start bit.
                //
                // rx_valid is only READ by this module.
                if (rx_valid && !rx_data) begin
                    next_state         = START;
                    next_cycle_counter = 4'd0;
                end

            end


            // =================================================
            // START
            // =================================================

            START: begin

                if (bclk_pulse) begin

                    // With 16x oversampling, check approximately
                    // halfway through the start bit.
                    if (cycle_counter == 4'd7) begin

                        // Still LOW -> valid start bit
                        if (!rx_data) begin
                            next_cycle_counter = 4'd0;
                            next_bit_counter   = 3'd0;
                            next_state         = RECEIVE;
                        end

                        // Went HIGH -> false start
                        else begin
                            next_cycle_counter = 4'd0;
                            next_state         = IDLE;
                        end

                    end

                    else begin
                        next_cycle_counter =
                            cycle_counter + 1'b1;
                    end

                end

            end


            // =================================================
            // RECEIVE
            // =================================================

            RECEIVE: begin

                if (bclk_pulse) begin

                    if (cycle_counter == 4'd15) begin

                        next_cycle_counter = 4'd0;

                        // UART sends LSB first.
                        // Store each serial bit in its
                        // corresponding position.
                        next_sipo[bit_counter] = rx_data;

                        // Last data bit received
                        if (bit_counter == 3'd7) begin
                            next_bit_counter = 3'd0;
                            next_state       = STOP;
                        end

                        else begin
                            next_bit_counter =
                                bit_counter + 1'b1;
                        end

                    end

                    else begin
                        next_cycle_counter =
                            cycle_counter + 1'b1;
                    end

                end

            end


            // =================================================
            // STOP
            // =================================================

            STOP: begin

                if (bclk_pulse) begin

                    if (cycle_counter == 4'd15) begin

                        next_cycle_counter = 4'd0;

                        // Valid UART stop bit must be HIGH.
                        if (rx_data) begin
                            next_rx_hold_register = temp_sipo;
                        end

                        next_state = IDLE;

                    end

                    else begin
                        next_cycle_counter =
                            cycle_counter + 1'b1;
                    end

                end

            end


            default: begin
                next_state = IDLE;
            end

        endcase

    end


    // =========================================================
    // Output combinational logic
    // =========================================================

    always_comb begin
        cts_n = 1'b0;
    end


endmodule