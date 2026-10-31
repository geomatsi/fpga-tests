module i2s_sine_test
(
    // infrastructure part
    input clk,
    input rst,
    input btn,

    // i2s part
    output       HP_BCK,
    output       HP_WS,
    output       HP_DIN,

    // spi part
    input  sclk,
    input  cs_n,
    input  mosi,
    output miso,

    // leds part
    output [5:0] leds
);

wire bck;
wire bck_fall;
wire rst_n;
wire btn_pressed;

// Both on-board buttons: synchronized and debounced (5 ms at 27 MHz).
// rst also gives the power-on reset: rst_n is low for the first POR_CYCLES
// clocks after configuration and while rst is pressed.
btn_reset #(.DEBOUNCE(135000)) rst_block(
    .clk(clk),
    .btn(rst),
    .pressed(),
    .rst_n(rst_n)
);

btn_reset #(.DEBOUNCE(135000)) btn_block(
    .clk(clk),
    .btn(btn),
    .pressed(btn_pressed),
    .rst_n()
);

// I2S bit clock from 27 MHz: 27 MHz / 18 = 1.5 MHz. All logic runs on clk;
// bck only drives the HP_BCK pin, bck_fall is the bit-rate enable.
clk_div_en #(.DIV(18)) audio_bit_clk(
    .clk(clk),
    .rst_n(rst_n),
    .tick(),
    .tick_fall(bck_fall),
    .clk_out(bck)
);

// Tick the NCO once per frame, on the data request before the L load
wire frame_tick;

wire signed [16:0] cos_o;
wire signed [16:0] sin_o;
wire valid;

wire signed [15:0] sin_sat = (sin_o >  17'sd32767) ? 16'sd32767 : (sin_o < -17'sd32768) ? -16'sd32768 : sin_o[15:0];

// Latch the NCO output on each request; the driver reads it one BCK later.
// The same sample goes to both channels (the NCO result for this tick lands
// well before the next frame)
reg signed [15:0] audio;
always @(posedge clk or negedge rst_n)
    if (!rst_n)          audio <= 16'sd0;
    else if (frame_tick) audio <= sin_sat;

// btn toggles the I2S driver reset: one press stops the output, the next resumes
reg btn_pressed_q = 1'b0;
reg i2s_rst_n     = 1'b1;

always @(posedge clk or negedge rst_n)
    if (!rst_n) begin
        btn_pressed_q <= 1'b0;
        i2s_rst_n     <= 1'b1;
    end
    else
    begin
        btn_pressed_q <= btn_pressed;
        if (btn_pressed & ~btn_pressed_q)       // press edge, once per press
            i2s_rst_n <= ~i2s_rst_n;
    end

// I2S audio driver
audio_drive audio_out(
    .clk(clk),
    .rst_n(i2s_rst_n),
    .bck(bck),
    .bck_fall(bck_fall),

    .ldata(audio),
    .rdata(audio),
    .req(frame_tick),

    .HP_BCK(HP_BCK),
    .HP_WS(HP_WS),
    .HP_DIN(HP_DIN)
);

// SPI

wire [7:0] rx_byte;
wire [7:0] tx_byte;
wire data_valid;

reg  [7:0] rx_byte_reg;
reg  [7:0] tx_byte_reg;

spi_slave_oversampled spi_block(
    .clk(clk),
    .CS_N(cs_n),
    .SCLK(sclk),
    .MOSI(mosi),
    .MISO(miso),

    .data_valid(data_valid),
    .rx_byte(rx_byte),
    .tx_byte(tx_byte)
);

localparam [7:0] FREQ_DEFAULT = 8'd150;     // 4 * 150 = 600 Hz until the MCU sets a frequency

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    begin
        tx_byte_reg <= 8'd0;
        rx_byte_reg <= FREQ_DEFAULT;
    end
    else if (data_valid)
    begin
        tx_byte_reg <= rx_byte;
        rx_byte_reg <= rx_byte;
    end
end

assign tx_byte = tx_byte_reg;

// NCO phase step from the frequency register:
//
// step  = f_out / f_s * 2^32
// f_s   = 1.5 MHz / 32 = 46875 Hz
// f_out = rx_byte_reg << 2 = 4 * rx_byte_reg
// =>  step = rx_byte_reg * (4 * 2^32 / 46875) = rx_byte_reg * 366503.876 ≈ rx_byte_reg * 366504
// e.g. rx_byte_reg = 150 -> 600 Hz -> step = 54975600 (exact: 54975581)
// Range: rx_byte_reg is 8-bit, so f_out = 0 .. 1020 Hz in 4 Hz steps

localparam [18:0] REG_TO_STEP = 19'd366504;   // round(4 * 2^32 / 46875)

reg [31:0] step;

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        step <= 32'd0;
    else
        step <= rx_byte_reg * REG_TO_STEP;

// Cordic sine generator
nco_cordic sine_wave(
    .clk(clk),
    .rst_n(rst_n),
    .tick(frame_tick),
    .step(step),
    .sin_o(sin_o),
    .cos_o(cos_o),
    .valid(valid)
);

// LEDs

control_leds leds_block(
    .clk(clk),
    .cmd(rx_byte_reg),
    .leds(leds)
);

endmodule
