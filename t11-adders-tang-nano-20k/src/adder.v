module half_adder
(
    input  wire x, y,
    output wire z,
    output wire carry_out
);
    xor(z, x, y);
    and(carry_out, x, y);
endmodule

module full_adder
(
    input wire x, y, carry_in,
    output wire z, carry_out
);

    wire [2:0] t;

    half_adder HA1(
        .x         (x),
        .y         (y),
        .z         (t[0]),
        .carry_out (t[1])
    );

    half_adder HA2(
        .x         (carry_in),
        .y         (t[0]),
        .z         (z),
        .carry_out (t[2])
    );

    or(carry_out, t[1], t[2]);

endmodule

module cascaded_adder
#(
    parameter WIDTH = 8
)
(
    input  [WIDTH - 1 : 0] x,
    input  [WIDTH - 1 : 0] y,
    input  carry_in,

    output [WIDTH - 1 : 0] z,
    output carry_out
);

    wire [WIDTH : 0] carry;

    assign carry[0] = carry_in;

    generate
        genvar i;
        for (i = 0; i <= WIDTH - 1; i = i + 1)
        begin: stage
            full_adder adder(
                .x         (x[i]),
                .y         (y[i]),
                .carry_in  (carry[i]),
                .z         (z[i]),
                .carry_out (carry[i + 1])
            );
        end
    endgenerate

    assign carry_out = carry[WIDTH];

endmodule