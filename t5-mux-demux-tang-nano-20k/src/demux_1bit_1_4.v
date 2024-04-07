module demux_1bit_1_4_shift(
    input din,
    input [1:0] sel,
    output reg dout0, dout1, dout2, dout3
);
    always @ (*)
        {dout3, dout2, dout1, dout0} = din << sel;
endmodule

module demux_1bit_1_4_case(
    input din,
    input [1:0] sel,
    output reg dout0, dout1, dout2, dout3
);
    always @ (*)
        begin
            case (sel)
                2'b00:
                    begin
                        dout0 = din; dout1 = 0; dout2 = 0; dout3 = 0;
                    end
                2'b01:
                    begin
                        dout0 = 0; dout1 = din; dout2 = 0; dout3 = 0;
                    end
                2'b10:
                    begin
                        dout0 = 0; dout1 = 0; dout2 = din; dout3 = 0;
                    end
                2'b11:
                    begin
                        dout0 = 0; dout1 = 0; dout2 = 0; dout3 = din;
                    end
            endcase
        end
endmodule