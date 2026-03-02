// ============================================================
// ID: rtl2 — 1-Cycle High Pulse Detector (0->1->0)
// ============================================================
// Goal: detect exactly-one-cycle high pulse using 2-cycle history. 

module rtl2_one_cycle_pulse (
  input  logic clk,
  input  logic rst_n,
  input  logic sig_in,
  output logic onecycle_pulse
);

  // TODO: Two history registers (d1,d2).
  // Why: need a 3-sample window: (d2,d1,current).
  logic d1, d2;
  logic sig_delay;
  // TODO: Shift history each clock (always_ff).
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin 
      d1 <= 1'b0;
      d2 <= 1'b0;
    end else begin
      d1 <= sig_in;
      d2 <= d1;    
    end
  end

  // TODO: Detect pattern 0,1,0.
  
  assign onecycle_pulse = (~sig_in & d1 & ~d2);

  // TODO: Reset values for d1/d2.

endmodule
