module mux_2bit_2_1_ternary(
    input [1:0] d0,
    input [1:0] d1,
    input sel,
    output [1:0] y
);
    assign y = sel ? d1 : d0;
endmodule

module mux_2bit_2_1_if(
    input [1:0] d0,
    input [1:0] d1,
    input sel,
    output reg [1:0] y
);
    always @ (*)
        begin
            if (sel)
                y = d1;
            else
                y = d0;
        end
endmodule

module mux_2bit_2_1_case(
    input [1:0] d0,
    input [1:0] d1,
    input sel,
    output reg [1:0] y
);
    always @ (*)
        begin
            case (sel)
                0: y = d0;
                1: y = d1;
            endcase
        end
endmodule