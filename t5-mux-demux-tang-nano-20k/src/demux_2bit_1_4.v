module demux_2bit_1_4_block(
    input  [1:0] din,
    input  [1:0] sel,
    output [1:0] dout0,
    output [1:0] dout1,
    output [1:0] dout2,
    output [1:0] dout3
);
    demux_1bit_1_4_shift demux0(
        .din(din[0]),
        .sel(sel),
        .dout0(dout0[0]),
        .dout1(dout1[0]),
        .dout2(dout2[0]),
        .dout3(dout3[0])
    );

    demux_1bit_1_4_shift demux1(
        .din(din[1]),
        .sel(sel),
        .dout0(dout0[1]),
        .dout1(dout1[1]),
        .dout2(dout2[1]),
        .dout3(dout3[1])
    );

endmodule