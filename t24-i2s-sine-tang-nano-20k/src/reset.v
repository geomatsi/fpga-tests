// btn_reset: push-button conditioner and power-on reset generator
//
// No reset input: the flops start from their declaration initializers, which
// the FPGA loads at the end of configuration (Gowin: GSR -> DFF INIT).
module btn_reset #(
    parameter integer DEBOUNCE   = 135000,  // filter length in clk cycles, >= 2 (5 ms at 27 MHz)
    parameter integer POR_CYCLES = 1024     // rst_n low time after configuration in clk cycles, >= 2
)(
    input  clk,                             // system clock; all outputs are in this domain
    input  btn,                             // raw button pin, asynchronous, 1 = pressed
    output pressed,                         // btn synchronized and debounced: follows btn once it has held a new level for DEBOUNCE clocks (+2 sync)
    output rst_n                            // active-low reset: low for POR_CYCLES clocks after configuration and while pressed; registered, so safe for async reset inputs
);
    localparam integer DW = $clog2(DEBOUNCE);
    localparam integer PW = $clog2(POR_CYCLES);

    // synthesis translate_off
    initial if (DEBOUNCE < 2 || POR_CYCLES < 2) begin
        $display("btn_reset: DEBOUNCE and POR_CYCLES must be >= 2 (got %0d, %0d)", DEBOUNCE, POR_CYCLES);
        $finish;
    end
    // synthesis translate_on

    // ---- 1. Synchronizer: raw pin -> clk domain -----------------------------
    reg [1:0] sync = 2'b00;
    always @(posedge clk)
        sync <= {sync[0], btn};

    wire btn_s = sync[1];

    // ---- 2. Debounce: accept a new level after DEBOUNCE stable clocks -------
    // db_cnt counts clocks with btn_s != pressed_r; any return to the current
    // level restarts the count.
    reg [DW-1:0] db_cnt    = {DW{1'b0}};
    reg          pressed_r = 1'b0;

    always @(posedge clk)
        if (btn_s == pressed_r)
            db_cnt <= {DW{1'b0}};
        else if (db_cnt == DEBOUNCE - 1) begin
            db_cnt    <= {DW{1'b0}};
            pressed_r <= btn_s;
        end else
            db_cnt <= db_cnt + 1'b1;

    // ---- 3. Power-on reset: count POR_CYCLES clocks after configuration -----
    // por_cnt stops at POR_CYCLES - 1 and stays there until reconfiguration.
    reg [PW-1:0] por_cnt = {PW{1'b0}};
    wire         por_done = (por_cnt == POR_CYCLES - 1);

    always @(posedge clk)
        if (!por_done)
            por_cnt <= por_cnt + 1'b1;

    // ---- 4. Reset output: low during POR or while the button is pressed -----
    reg rst_n_r = 1'b0;
    always @(posedge clk)
        rst_n_r <= por_done & ~pressed_r;

    assign pressed = pressed_r;
    assign rst_n   = rst_n_r;
endmodule
