module shift_example(
    input  [1:0] key,
    output [5:0] led
);

    wire [5:0] leds_bus;
    wire [5:0] loop_bus;
    wire clk;
    wire rst;

    assign led[5:0] = ~leds_bus;
    assign clk = key[0];
    assign rst = key[1];

    parameter WIDTH = 6;
    parameter SHIFT = 3;

    shift_reg_naive #(.WIDTH(WIDTH), .SHIFT(SHIFT)) rotator(
            .clock (clk),
            .reset (rst),
            .x     (loop_bus),
            .shamt (3'b001),
            .z     (leds_bus)
    );

    unit_delay #(.WIDTH(WIDTH)) delay(
        .clock (clk),
        .d_in  (leds_bus),
        .d_out (loop_bus)
    );

endmodule
