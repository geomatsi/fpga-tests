module sr_test(
    input  [1:0] key,
    output [5:0] led
);

// turn off active-low leds 2..5
assign led[5:2] = 4'b1111;

// connect pins to sr_latch:
// - keys to sr inputs
// - leds to sr outputs
sr_latch sr_latch
(
    .s (key[0]),
    .r (key[1]),
    .q (led[0]),
    .q_n (led[1])
);

endmodule