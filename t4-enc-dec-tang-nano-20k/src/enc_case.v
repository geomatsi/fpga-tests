module enc_case(
    input [7:0] in,
    input enable,
    output reg [2:0] out
);
    always @ (*)
        begin
            out = 0;
            if (enable) begin
                case (in)
                    16'h01 : out = 0;
                    16'h02 : out = 1;
                    16'h04 : out = 2;
                    16'h08 : out = 3;
                    16'h10 : out = 4;
                    16'h20 : out = 5;
                    16'h40 : out = 6;
                    16'h80 : out = 7;
                endcase
            end
        end
endmodule
