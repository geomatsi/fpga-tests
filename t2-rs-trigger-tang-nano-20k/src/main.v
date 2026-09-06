module sr_test(
    input  [1:0] key,
    output [5:0] led
);

// sr_latch example
// connect pins to sr_latch:
// - keys to sr inputs
// - leds 0..1 to sr outputs

sr_latch sr_latch
(
    .s   (key[0]),
    .r   (key[1]),
    .q   (led[0]),
    .q_n (led[1])
);

// d_latch example
// connect pins to sr_latch:
// - keys to d_latch inputs
// - leds 2..3 to d_latch outputs
d_latch d_latch
(
    .clk (key[0]),
    .d   (key[1]),
    .q   (led[2]),
    .q_n (led[3])
);

// d_trigger example
// connect pins to sr_latch:
// - keys to d_trigger inputs
// - leds 4..5 to d_trigger outputs
d_trigger d_trigger
(
    .clk (key[0]),
    .d   (key[1]),
    .q   (led[4]),
    .q_n (led[5])
);

endmodule