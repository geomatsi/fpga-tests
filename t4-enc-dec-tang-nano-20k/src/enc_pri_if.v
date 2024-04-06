module enc_pri_if(
    input [7:0] in,
    input enable,
    output reg [2:0] out
);
    always @ (*)
        begin
            out = 0;
            if (enable) begin
                if (in[0] == 1'b1)
                    out = 0;
                else if (in[1] == 1'b1)
                    out = 1;
                else if (in[2] == 1'b1)
                    out = 2;
                else if (in[3] == 1'b1)
                    out = 3;
                else if (in[4] == 1'b1)
                    out = 4;
                else if (in[5] == 1'b1)
                    out = 5;
                else if (in[6] == 1'b1)
                    out = 6;
                else if (in[7] == 1'b1)
                    out = 7;
            end
        end
endmodule
