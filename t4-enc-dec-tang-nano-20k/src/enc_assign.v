module enc_assign(
    input [7:0] in,
    input enable,
    output [2:0] out
);

    assign out[0] = enable & (in[1] | in[3] | in[5] | in[7]);
    assign out[1] = enable & (in[2] | in[3] | in[6] | in[7]);
    assign out[2] = enable & (in[4] | in[6] | in[6] | in[7]);

endmodule
