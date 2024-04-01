module button_led(
    input   wire clk,
    input  [1:0] button,
    output [5:0] led
);

wire a = button[0];
wire b = button[1];

assign led[0] = ~a;
assign led[1] = ~b;
assign led[2] = ~(a | b);
assign led[3] = ~(a & b);
assign led[4] = ~(a ^ b);
assign led[5] = 0;

endmodule
