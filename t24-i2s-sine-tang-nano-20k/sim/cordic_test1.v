`timescale 1ns/1ps

module testbench;
    reg clk = 0, rst_n = 0;
    always #8.333 clk = ~clk;                        // 60 MHz
    // sample tick every 40 clocks (real design: 1.5 MHz clk, tick every 32)
    reg [7:0] c = 0; reg tick = 0;
    always @(posedge clk) begin tick <= (c == 39); c <= (c == 39) ? 0 : c + 1; end
    wire signed [16:0] s, co; wire v;
    // step = 600 / 48000 * 2^32: 1/80 of the tick rate, so one sine period
    // is 80 samples (600 Hz at a 48 kHz tick; 18.75 kHz at this sim's 1.5 MHz tick)
    nco_cordic #(.ITER(16)) dut(.clk(clk), .rst_n(rst_n), .tick(tick),
                                .step(32'd53687091), .sin_o(s), .cos_o(co), .valid(v));
    integer f, n = 0;
    initial begin
        f = $fopen("out.txt", "w");
        #100 rst_n = 1;
    end
    always @(posedge clk) if (v) begin
        $fwrite(f, "%0d %0d\n", s, co);
        n = n + 1;
        if (n == 4800) begin $fclose(f); $finish; end
    end

    initial
        $dumpvars;
endmodule
