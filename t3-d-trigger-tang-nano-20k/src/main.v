module d_trigger_example(
    input  clk,
    input  [1:0] key,
    output [5:0] led
);

// d_latch example
// connect pins to d_latch:
// - keys to d_latch inputs
// - leds 0 to d_latch output
d_latch d_latch
(
    .clk (key[0]),
    .d   (key[1]),
    .q   (led[0])
);

// d_trigger example
// connect pins to d_trigger:
// - keys to d_trigger inputs
// - leds 1 to d_trigger output
d_trigger d_trigger
(
    .clk (key[0]),
    .d   (key[1]),
    .q   (led[1])
);

// jk_trigger example
// connect pins to jk_trigger:
// - keys to d_trigger inputs
// - leds 2 to d_trigger output
jk_trigger jk_trigger
(
    .clk (key[0]),
    .j   (key[1]),
    .k   (key[1]),
    .q   (led[2])
);

endmodule