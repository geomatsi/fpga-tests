module enc_pri_assign(
    input [7:0] in,
    input enable,
    output [2:0] out
);

    assign out = (enable) ? (
        (in[7] == 1'b1) ? 7 :
        (in[6] == 1'b1) ? 6 :
        (in[5] == 1'b1) ? 5 :
        (in[4] == 1'b1) ? 4 :
        (in[3] == 1'b1) ? 3 :
        (in[2] == 1'b1) ? 2 :
        (in[1] == 1'b1) ? 1 :
        (in[0] == 1'b1) ? 0 : 4'bxxxx
    ) : 0;

endmodule