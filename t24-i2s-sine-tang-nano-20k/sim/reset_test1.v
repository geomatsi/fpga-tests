`timescale 1ns/1ps

// btn_reset: power-on reset and button debounce, with small DEBOUNCE/POR_CYCLES
//   - rst_n is low from time 0 and rises exactly POR_CYCLES clocks later
//   - a button held through POR keeps rst_n low until it is released and debounced
//   - a pulse of DEBOUNCE-1 clocks is ignored; DEBOUNCE clocks is accepted
//   - a bouncing press and a bouncing release each give one clean edge
//   - pressed follows a stable pin after LAT_P clocks, rst_n one clock later
module testbench;
    localparam DEB   = 8;                            // DEBOUNCE
    localparam POR   = 16;                           // POR_CYCLES
    localparam LAT_P = 2 + DEB;                      // pin -> pressed: 2 sync flops + filter

    reg clk = 0;
    always #18.519 clk = ~clk;                       // 27 MHz

    // a: button idle at power-up; b: button held at power-up
    reg btn_a = 0, btn_b = 1;
    wire pressed_a, rst_n_a, pressed_b, rst_n_b;

    btn_reset #(.DEBOUNCE(DEB), .POR_CYCLES(POR)) dut_a(.clk(clk), .btn(btn_a), .pressed(pressed_a), .rst_n(rst_n_a));
    btn_reset #(.DEBOUNCE(DEB), .POR_CYCLES(POR)) dut_b(.clk(clk), .btn(btn_b), .pressed(pressed_b), .rst_n(rst_n_b));

    integer errs = 0;
    integer clks = 0;                                // posedges since time 0
    always @(posedge clk) clks = clks + 1;

    // edge counters for dut_a
    integer press_a = 0, rel_a = 0, rfall_a = 0, rrise_a = 0;
    reg pressed_q = 0, rst_n_q = 0;
    always @(posedge clk) begin
        #1;                                          // look after the DUT has updated
        if ( pressed_a && !pressed_q) press_a = press_a + 1;
        if (!pressed_a &&  pressed_q) rel_a   = rel_a + 1;
        if (!rst_n_a   &&  rst_n_q)   rfall_a = rfall_a + 1;
        if ( rst_n_a   && !rst_n_q)   rrise_a = rrise_a + 1;
        pressed_q = pressed_a;
        rst_n_q   = rst_n_a;
    end

    task check(input cond, input [8*48-1:0] msg);
    begin
        if (!cond) begin
            errs = errs + 1; $display("%t: FAIL %0s", $time, msg);
        end
    end
    endtask

    // drive the pin on negedge, hold it for n clocks
    task drive_a(input v, input integer n);
    begin
        @(negedge clk) btn_a = v;
        repeat (n - 1) @(negedge clk);
    end
    endtask

    // clocks from now until sig == v (sampled after posedge), up to a limit
    integer t0;
    task wait_a(input which, input v, output integer dt);   // which: 0 = pressed_a, 1 = rst_n_a
    begin
        t0 = clks;
        dt = -1;
        while (dt < 0 && clks - t0 < 4*(DEB + POR)) begin
            @(posedge clk) #1;
            if ((which ? rst_n_a : pressed_a) === v) dt = clks - t0;
        end
    end
    endtask

    integer dt;

    initial begin
        // ---- power-on reset ----------------------------------------------
        #1;
        check(rst_n_a === 1'b0, "rst_n_a not low at time 0");
        check(rst_n_b === 1'b0, "rst_n_b not low at time 0");
        wait (rst_n_a === 1'b1);
        check(clks == POR, "POR length");
        if (clks != POR) $display("  rst_n_a rose after %0d clocks, expected %0d", clks, POR);

        // button b held through POR: still in reset, until released
        repeat (2*DEB) @(posedge clk);
        check(rst_n_b === 1'b0, "rst_n_b released while button held");
        check(pressed_b === 1'b1, "pressed_b not set while held");
        @(negedge clk) btn_b = 0;
        repeat (LAT_P + 2) @(posedge clk);
        #1 check(rst_n_b === 1'b1, "rst_n_b not released after button release");

        // ---- glitch filter -----------------------------------------------
        repeat (4) @(negedge clk);
        drive_a(1, DEB - 1);
        drive_a(0, 4*DEB);
        check(press_a == 0 && rfall_a == 0, "DEBOUNCE-1 pulse not filtered");

        drive_a(1, DEB);
        drive_a(0, 4*DEB);
        check(press_a == 1 && rel_a == 1, "DEBOUNCE pulse not accepted");
        check(rfall_a == 1 && rrise_a == 2, "rst_n_a did not pulse for DEBOUNCE pulse");

        // ---- bouncing press, then exact latency of a clean press ----------
        drive_a(1, 3); drive_a(0, 2); drive_a(1, 5); drive_a(0, 1);
        drive_a(1, 2*DEB);
        check(press_a == 2, "bouncing press: expected one pressed edge");
        drive_a(1, 2*DEB);

        // ---- bouncing release --------------------------------------------
        drive_a(0, 2); drive_a(1, 4); drive_a(0, 3); drive_a(1, 1);
        drive_a(0, 2*DEB);
        check(rel_a == 2, "bouncing release: expected one released edge");
        check(rst_n_a === 1'b1, "rst_n_a not back high after release");

        // ---- latency: pin -> pressed -> rst_n ------------------------------
        @(negedge clk) btn_a = 1;
        wait_a(0, 1, dt);
        check(dt == LAT_P, "press latency");
        if (dt != LAT_P) $display("  pressed after %0d clocks, expected %0d", dt, LAT_P);
        wait_a(1, 0, dt);
        check(dt == 1, "rst_n assert latency");
        @(negedge clk) btn_a = 0;
        wait_a(0, 0, dt);
        check(dt == LAT_P, "release latency");
        if (dt != LAT_P) $display("  released after %0d clocks, expected %0d", dt, LAT_P);
        wait_a(1, 1, dt);
        check(dt == 1, "rst_n release latency");

        repeat (4) @(posedge clk);
        $display("dut_a: presses=%0d releases=%0d rst_n falls=%0d rises=%0d",
                 press_a, rel_a, rfall_a, rrise_a);
        $display("errors = %0d: %s", errs, errs ? "FAIL" : "PASS");
        $finish;
    end

    initial
        $dumpvars;
endmodule
