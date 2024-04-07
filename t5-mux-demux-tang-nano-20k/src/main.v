module demux_example(
    input  [1:0] key,
    output [5:0] led
);

wire din = 1'b1;
wire [5:0] out;

assign led[5:0] = ~out[5:0];

demux_1bit_1_4_case mux0(
    .din   (din),
    .sel   (key),
    .dout0 (out[0]),
    .dout1 (out[1]),
    .dout2 (out[2]),
    .dout3 (out[3])
);

endmodule
