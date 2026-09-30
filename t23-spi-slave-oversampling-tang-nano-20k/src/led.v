module control_leds(
    input        clk,
    input  [7:0] cmd,
    output [5:0] leds
);

assign leds[0] = ~cmd[0];
assign leds[1] = ~cmd[1];
assign leds[2] = ~cmd[2];
assign leds[3] = ~cmd[3];
assign leds[4] = ~cmd[4];
assign leds[5] = ~cmd[5];

endmodule