module mux_2bit_4_1_case(
    input [1:0] d0, d1, d2, d3,
    input [1:0] sel,
    output reg [1:0] y
);
    always @ (*)
        begin
            case (sel)
                2'b00: y = d0;
                2'b01: y = d1;
                2'b10: y = d2;
                2'b11: y = d3;
            endcase
        end
endmodule

module mux_2bit_4_1_ternary(
    input [1:0] d0, d1, d2, d3,
    input [1:0] sel,
    output [1:0] y
);
    assign y = sel[1] ? (sel[0] ? d3 : d2) : (sel[0] ? d1 : d0);
endmodule

module mux_2bit_4_1_block(
    input [1:0] d0, d1, d2, d3,
    input [1:0] sel,
    output [1:0] y
);
    wire [1:0] w01, w23;

    mux_2bit_2_1_ternary mux0(.d0(d0), .d1(d1), .sel(sel[0]), .y(w01));
    mux_2bit_2_1_ternary mux1(.d0(d2), .d1(d3), .sel(sel[0]), .y(w23));
    mux_2bit_2_1_ternary mux2(.d0(w01), .d1(w23), .sel(sel[1]), .y(y));

endmodule
