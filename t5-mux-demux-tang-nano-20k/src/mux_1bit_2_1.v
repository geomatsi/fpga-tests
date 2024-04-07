module mux_1bit_2_1_assign(
    input d0,
    input d1,
    input sel,
    output y
);
    assign y = (sel & d1) | ((~sel) & d0);
endmodule

module mux_1bit_2_1_ternary(
    input d0,
    input d1,
    input sel,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module mux_1bit_2_1_if(
    input d0,
    input d1,
    input sel,
    output reg y
);
    always @ (*)
        begin
            if (sel)
                y = d1;
            else
                y = d0;
        end
endmodule

module mux_1bit_2_1_case(
    input d0,
    input d1,
    input sel,
    output reg y
);
    always @ (*)
        begin
            case (sel)
                0: y = d0;
                1: y = d1;
            endcase
        end
endmodule