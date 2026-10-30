`timescale 1ns/1ps

// audio_drive: Philips I2S output checked against a DAC-side receiver model
//   - each L/R word decoded from HP_DIN matches the sample given on req
//     (ldata/rdata are only valid until the bck_fall after req, then scrambled)
//   - WS toggles every 16 BCKs and the words decode with the Philips 1-BCK offset
//   - req fires once per frame (every 32 BCKs)
//   - HP_WS/HP_DIN change only right after a BCK falling edge
module testbench;
    localparam DIV = 18;                             // 27 MHz / 18 = 1.5 MHz BCK, as in top.v
    localparam NF  = 16;                             // frames to check

    reg clk = 0, rst_n = 0;
    always #18.519 clk = ~clk;                       // 27 MHz

    wire bck, bck_fall, req, ws, din;
    reg [15:0] ldata = 16'hxxxx, rdata = 16'hxxxx;

    clk_div_en #(.DIV(DIV)) div(.clk(clk), .rst_n(rst_n), .tick(), .tick_fall(bck_fall), .clk_out(bck));
    audio_drive dut(.clk(clk), .rst_n(rst_n), .bck(bck), .bck_fall(bck_fall),
                    .ldata(ldata), .rdata(rdata), .req(req),
                    .HP_BCK(), .HP_WS(ws), .HP_DIN(din));

    integer errs = 0;

    // producer: new random L/R pair on each req, scrambled on the bck_fall that reads it
    reg [15:0] expl [0:NF+3];
    reg [15:0] expr [0:NF+3];
    integer n = 0, seed = 1;
    reg pend = 0;
    always @(posedge clk) begin
        if (pend && bck_fall) begin
            ldata <= 16'hDEAD; rdata <= 16'hBEEF; pend <= 0;
        end
        if (req && n < NF+4) begin
            expl[n] = $random(seed); expr[n] = $random(seed);
            ldata <= expl[n]; rdata <= expr[n]; pend <= 1;
            n = n + 1;
        end
    end

    // req period: exactly one frame (32 BCKs)
    integer clks = 0, last_req = -1;
    always @(posedge clk) if (rst_n) begin
        clks = clks + 1;
        if (req) begin
            if (last_req >= 0 && clks - last_req != 32*DIV) begin
                errs = errs + 1; $display("req period %0d clks, expected %0d", clks - last_req, 32*DIV);
            end
            last_req = clks;
        end
    end

    // HP_WS/HP_DIN may change only in the clk after bck_fall (half a BCK before the rising edge)
    reg din_q = 0, ws_q = 0, bf_q = 0;
    always @(posedge clk) begin
        if (rst_n && (din !== din_q || ws !== ws_q) && !bf_q) begin
            errs = errs + 1; $display("%t: HP_WS/HP_DIN changed away from a BCK fall", $time);
        end
        din_q <= din; ws_q <= ws; bf_q <= bck_fall;
    end

    // DAC model (Philips I2S): sample on BCK rise; a word is the 16 bits ending on the
    // edge where WS is first seen changed (that edge carries the LSB)
    reg [15:0] sr = 0, word_l = 0, word_r = 0;       // word_l/word_r: last decoded words, for the waveform
    reg ws_r = 0;
    integer gotl = 0, gotr = 0, bits = 0;
    always @(posedge bck) begin
        sr = {sr[14:0], din};
        bits = bits + 1;
        if (ws !== ws_r) begin
            if (gotl + gotr > 0 && bits != 16) begin
                errs = errs + 1; $display("%t: WS slot of %0d BCKs, expected 16", $time, bits);
            end
            bits = 0;
            if (!ws_r) begin
                word_l = sr;
                if (gotl < NF && word_l !== expl[gotl]) begin
                    errs = errs + 1; $display("L%0d: got %h, expected %h", gotl, word_l, expl[gotl]);
                end
                gotl = gotl + 1;
            end else begin
                word_r = sr;
                if (gotr < NF && word_r !== expr[gotr]) begin
                    errs = errs + 1; $display("R%0d: got %h, expected %h", gotr, word_r, expr[gotr]);
                end
                gotr = gotr + 1;
            end
        end
        ws_r <= ws;
    end

    task report;
    begin
        $display("frames: L words=%0d R words=%0d (checked %0d each)", gotl, gotr, NF);
        $display("errors = %0d: %s", errs, errs ? "FAIL" : "PASS");
        $finish;
    end
    endtask

    initial begin
        #100 rst_n = 1;
        wait (gotr >= NF);
        report;
    end

    initial begin
        #(100 + 37.037*DIV*32*(NF+4));
        errs = errs + 1; $display("timeout");
        report;
    end

    initial
        $dumpvars;
endmodule
