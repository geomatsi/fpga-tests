module i2s_sine_test
(
    input clk,
    input rst,

    output       HP_BCK,
    output       HP_WS,
    output       HP_DIN
);

wire clk_1p5m;
wire rst_n;

assign rst_n = !rst ;

// I2S bit clock from 27 MHz: 27 MHz / 18 = 1.5 MHz
clk_div_en #(.DIV(18)) audio_bit_clk(
    .clk(clk),
    .rst_n(rst_n),
    .tick(),
    .tick_fall(),
    .clk_out(clk_1p5m)
);

wire req_data_s;

// req pulses twice per frame (before L and R loads); tick the NCO only on the
// one before the L load (WS still high from the previous R slot)
wire frame_tick = req_data_s & HP_WS;

localparam [31:0] STEP = 32'd54975581; // f_out / f_s * 2^32 = 600 / 46875 * 2^32; f_s = 1.5 MHz / 32
wire signed [16:0] cos_o;
wire signed [16:0] sin_o;
wire valid;

wire signed [15:0] sin_sat = (sin_o >  17'sd32767) ? 16'sd32767 : (sin_o < -17'sd32768) ? -16'sd32768 : sin_o[15:0];

// Hold one sample for the whole frame so L and R get the same value
// (the NCO result for this tick lands well before the next frame)
reg signed [15:0] audio;
always @(posedge clk_1p5m or negedge rst_n)
    if (!rst_n)          audio <= 16'sd0;
    else if (frame_tick) audio <= sin_sat;

// I2S audio driver
audio_drive audio_out(
    .clk_1p536m(clk_1p5m),
    .rst_n(rst_n),

    .idata(audio),
    .req(req_data_s),

    .HP_BCK(HP_BCK),
    .HP_WS(HP_WS),
    .HP_DIN(HP_DIN)
);

// Cordic sine generator
nco_cordic sine_wave(
    .clk(clk_1p5m),
    .rst_n(rst_n),
    .tick(frame_tick),
    .step(STEP),
    .sin_o(sin_o),
    .cos_o(cos_o),
    .valid(valid)
);

endmodule