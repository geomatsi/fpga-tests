// nco_cordic: sine/cosine NCO built on the Gowin CORDIC IP.
//
// Outputs one sin/cos sample per `tick`, held until the next one.
//   f_out = step * f_tick / 2^32
//
// Phase: 32-bit accumulator; 2^32 = one full turn (2*pi), wraps naturally.
//
// CORDIC IP config (src/cordic/cordic.ipc):
//   ROTATE, RADIAN, PIPELINE, ITER iterations, 17-bit x/y/theta
//   x_o = G*(x_i*cos(theta_i) - y_i*sin(theta_i))
//   y_o = G*(x_i*sin(theta_i) + y_i*cos(theta_i)),   G ~= 1.6468
//   theta_i must be in [-pi/2, pi/2]
//   rst active high; no valid/ready ports
//
//   x/y/theta format is Q2.15, and gain G is not compensated inside the IP.
module nco_cordic #(
    parameter integer ITER   = 16   // CORDIC iterations; must match the IP
)(
    input                    clk,
    input                    rst_n,  // async reset, active low
    input                    tick,   // 1-cycle sample strobe, rate f_tick
    input             [31:0] step,   // phase increment per tick (see f_out above)
    output reg signed [16:0] sin_o,  // Q2.15, +/-1.0 = +/-32768
    output reg signed [16:0] cos_o,  // Q2.15, +/-1.0 = +/-32768
    output reg               valid   // 1-cycle pulse: sin_o/cos_o just updated
);
    // ---- 1. Phase accumulator: phase += step on each tick -----------------
    // phase: unsigned integer 0 .. 2^32-1, a fraction of the full circle,
    // with full circle = 2^32:
    //   angle = phase / 2^32  [turns]  = phase / 2^32 * 2*pi  [rad]
    //   0 = 0,  2^30 = pi/2,  2^31 = pi,  3*2^30 = 3*pi/2
    //   1 LSB = 1/2^32 turn = 2*pi / 2^32 rad
    // Overflow past 2^32-1 back to 0 is the 2*pi -> 0 wrap; no modulo needed.
    reg [31:0] phase;
    always @(posedge clk or negedge rst_n)
        if (!rst_n)    phase <= 32'd0;
        else if (tick) phase <= phase + step;

    // ---- 2. Quadrant fold into [-pi/2, pi/2) ------------------------------
    // CORDIC accepts only [-pi/2, pi/2]. Angles in the left half-plane are
    // shifted by pi and the result negated:
    //   sin(a) = -sin(a -/+ pi),  cos(a) = -cos(a -/+ pi)
    //
    // p: top 16 bits of phase, read as signed: -32768..32767 <-> -pi..pi
    // phase is a fraction of the full circle, so its top two bits
    // (p[15:14] = phase[31:30]) split the circle into four quadrants:
    //   p[15:14] = 00: [0, pi/2)          11: [-pi/2, 0)
    //              01: [pi/2, pi)  fold   10: [-pi, -pi/2)  fold
    // phase[15:0] is not used for the angle: it accumulates the fraction of
    // step below 1 LSB of p and carries into p, keeping f_out exact on average.
    // Fold: flipping p[15] adds/subtracts 2^15 (= pi).
    // Negate: feed x_i = -X0 instead of X0 (y_i = 0), both outputs flip sign.
    localparam signed [16:0] X0 = 17'sd19898;  // 1/G * 2^15, cancels CORDIC gain

    wire signed [15:0] p    = phase[31:16];                   // p[15:14] = phase[31:30]
    wire               fold = p[15] ^ p[14];                  // quadrant 01 or 10
    wire signed [15:0] pf   = fold ? {~p[15], p[14:0]} : p;   // -16384..16383 <-> [-pi/2, pi/2)

    // Pipeline stage: register the folded angle and the matching x_i sign
    reg signed [15:0] pf_r;
    reg signed [16:0] x_r1;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            pf_r <= 16'sd0;
            x_r1 <= X0;
        end else begin
            pf_r <= pf;
            x_r1 <= fold ? -X0 : X0;
        end

    // ---- 3. Folded phase -> radians, Q2.15 --------------------------------
    // Values (real value = integer value * LSB):
    //   name     width  range                      LSB            real range
    //   pf_r     s16    -16384 .. 16383            pi/2^15 rad    [-pi/2, pi/2)
    //   PI_Q16   s19    205887                     2^-16          pi
    //   prod     s35    -3373252608 .. 3373046721  2^-31 rad      [-pi/2, pi/2)
    //   theta_i  s17    -51472 .. 51469            2^-15 rad      [-1.5708, 1.5707]
    //
    // pf LSB = 1/2^16 turn = pi / 2^15 rad, so  angle = pf * pi / 2^15  [rad]
    // Q2.15:  theta = angle * 2^15 = pf * pi
    // pi is not an integer: multiply by PI_Q16 = round(pi * 2^16), then
    // shift right by 16 with rounding.
    // |theta| <= 16384 * pi = 51472 < 2^16  -> fits 17-bit signed.
    localparam signed [18:0] PI_Q16 = 19'sd205887;   // pi * 2^16; 18 bits + sign
    wire signed [34:0] prod = pf_r * PI_Q16;          // 16 + 19 bits

    // Pipeline stage: theta_i and its x_i reach the IP on the same cycle
    reg signed [16:0] theta_i;
    reg signed [16:0] x_i;
    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            theta_i <= 17'sd0;
            x_i     <= X0;
        end else begin
            theta_i <= (prod + 35'sd32768) >>> 16;  // +0.5 LSB, then / 2^16: round to nearest
            x_i     <= x_r1;
        end

    // ---- 4. Gowin CORDIC IP: rotate (x_i, 0) by theta_i -------------------
    // With x_i = +/-X0 = +/-1/G and y_i = 0, the IP gain G cancels:
    //   x_o = +/-cos(theta_i),  y_o = +/-sin(theta_i)   (Q2.15)
    // The sign from the fold (step 2) undoes the pi shift, so x_o and y_o
    // are cos and sin of the original, unfolded angle.
    // PIPELINE: accepts a new input every clock; latency ~ITER cycles (step 5).
    wire signed [16:0] x_o, y_o, theta_o;
    CORDIC_Top u_cordic (
        .clk     (clk),
        .rst     (~rst_n),          // IP reset is active high
        .x_i     (x_i),             // +/-X0
        .y_i     (17'sd0),
        .theta_i (theta_i),         // Q2.15 rad, [-pi/2, pi/2)
        .x_o     (x_o),             // cos, Q2.15
        .y_o     (y_o),             // sin, Q2.15
        .theta_o (theta_o)          // residual angle, unused
    );

    // ---- 5. Output register: sample the IP LAT cycles after tick ----------
    // The IP has no valid output, so tick is delayed through a shift register
    // (dly) and the IP output is sampled when the delayed tick comes out.
    //
    // Timeline, E0 = the clock edge that sees tick = 1:
    //   E0          phase   <= phase + step       dly[0] <= 1
    //   E1          pf_r    <= fold(phase)        (step 2)
    //   E2          theta_i <= pf_r * pi          (step 3, IP input)
    //   E2 + ITER   x_o/y_o change                (IP latency = ITER, IPUG522 3.3)
    //   E(LAT)      sin_o/cos_o <= y_o/x_o        (dly[LAT-1] = 1)
    // A register clocked at E(LAT) captures what was set at E(LAT-1) or
    // earlier, so the new IP output is caught when
    //   LAT - 1 = 2 + ITER   ->   LAT = 3 + ITER
    // The 3 is therefore:
    //   2  register stages between tick and the IP input (pf_r, theta_i);
    //      phase adds nothing, it updates on E0 together with dly[0]
    //   1  the output register capturing x_o/y_o one edge after they change
    //
    // Until the first tick's E(LAT), sin_o/cos_o hold their reset value 0;
    // IP outputs before that are never sampled.
    // phase changes only on tick, so each IP result stays on x_o/y_o for a
    // whole tick period. LAT may exceed the tick period (the IP is pipelined).
    localparam integer LAT = 3 + ITER;
    reg [LAT-1:0] dly;                              // dly[i] = tick delayed i+1 cycles
    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            dly   <= {LAT{1'b0}};
            valid <= 1'b0;
            sin_o <= 17'sd0;
            cos_o <= 17'sd0;
        end else begin
            dly   <= {dly[LAT-2:0], tick};
            valid <= dly[LAT-1];                    // E(LAT), with sin_o/cos_o
            if (dly[LAT-1]) begin
                sin_o <= y_o;
                cos_o <= x_o;
            end
        end
endmodule