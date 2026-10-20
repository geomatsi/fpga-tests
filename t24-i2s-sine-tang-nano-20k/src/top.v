module i2s_sine_test
(
    input  sysclk,
    output [5:0] leds
);

// I2S bit clock from 27 MHz: 27 MHz / 18 = 1.5 MHz
clk_div_en #(.DIV(18)) u_bck (
    .clk(sysclk),
    .rst_n(rst_n),
    .tick(bck_rise),
    .tick_fall(bck_fall),
    .clk_out(HP_BCK)
);

endmodule