module dec_shift(
    input [2:0] in,
    input enable,
    output wire [7:0] out
);
    assign out = (enable) ? (1 << in) : 8'b0;
endmodule