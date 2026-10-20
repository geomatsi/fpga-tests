// clk_div_en: clock-enable divider (no derived clock domain)
//
// Generates, from the system clock `clk`:
//   tick      - 1-cycle pulse once every DIV clocks (same cycle clk_out rises)
//   tick_fall - 1-cycle pulse once every DIV clocks (same cycle clk_out falls)
//   clk_out   - registered square wave, period = DIV clocks, high for DIV/2
//               clocks (50% duty for even DIV). Intended for an output pin
//               such as I2S BCK, never as a clock for internal logic.
//
// Internal logic stays in the `clk` domain and uses the ticks as enables:
//   always @(posedge clk) if (tick_fall) ...   // e.g. change I2S data on BCK fall
//
// Example: 27 MHz / 18 = 1.5 MHz BCK  ->  clk_div_en #(.DIV(18))
//          60 MHz / 1280 = 46.875 kHz audio sample strobe  ->  #(.DIV(1280))
module clk_div_en #(
    parameter integer DIV = 18          // output period in clk cycles, DIV >= 2
)(
    input      clk,
    input      rst_n,                   // asynchronous reset, active low
    output reg tick,
    output reg tick_fall,
    output reg clk_out
);
    localparam integer W  = (DIV > 2) ? $clog2(DIV) : 1;
    localparam integer HI = DIV / 2;    // clocks clk_out stays high

    reg [W-1:0] cnt;

    // synthesis translate_off
    initial if (DIV < 2) begin
        $display("clk_div_en: DIV must be >= 2 (got %0d)", DIV);
        $finish;
    end
    // synthesis translate_on

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= {W{1'b0}};
            tick      <= 1'b0;
            tick_fall <= 1'b0;
            clk_out   <= 1'b0;
        end else begin
            tick      <= 1'b0;
            tick_fall <= 1'b0;

            if (cnt == DIV - 1) begin
                cnt     <= {W{1'b0}};
                clk_out <= 1'b1;        // rising edge of clk_out
                tick    <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
            end

            if (cnt == HI - 1) begin
                clk_out   <= 1'b0;      // falling edge of clk_out
                tick_fall <= 1'b1;
            end
        end
    end
endmodule