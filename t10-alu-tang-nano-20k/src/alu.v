`define ALU_AND 2'b00
`define ALU_ADD 2'b01
`define ALU_SLL 2'b10
`define ALU_SLT 2'b11

/* ALU AND block */

module alu_and
#(
    parameter WIDTH = 8
)
(
    input  [WIDTH - 1 : 0] x, y,
    output [WIDTH - 1 : 0] z
);
    assign z = x & y;
endmodule

/* ALU ADD block */

module alu_add
#(
    parameter WIDTH = 8
)
(
    input  [WIDTH - 1 : 0] x, y,
    input  carry_in,
    output [WIDTH - 1 : 0] z,
    output carry_out
);
    assign {carry_out, z} = x + y + carry_in;
endmodule

/* ALU SLL block */

module alu_sll
#(
    parameter WIDTH = 8,
    parameter SHIFT = 3
)
(
    input  [WIDTH - 1 : 0] x,
    input  [SHIFT - 1 : 0] shamt,
    output [WIDTH - 1 : 0] z
);
    assign z = x << shamt;
endmodule

/* ALU SLT block */

module alu_slt
#(
    parameter WIDTH = 8
)
(
    input  [WIDTH - 1 : 0] x, y,
    output [WIDTH - 1 : 0] z
);
    assign z = (x < y) ? 1 : 0;
endmodule

/* ALU structural implementation */

module alu_structural
#(
    parameter WIDTH = 4,
    parameter SHIFT = 2
)
(
    input  [WIDTH - 1 : 0] x, y,
    input  [SHIFT - 1 : 0] shamt,
    input  [1:0] operation,
    input  carry_in,

    output [WIDTH - 1 : 0] result,
    output overflow,
    output zero
);

    // storage for the results of all 4 operations
    wire [4 * WIDTH - 1 : 0] t;

    // AND
    alu_and #(.WIDTH(WIDTH)) op_and (
        .x (x),
        .y (y),
        .z (t[WIDTH - 1 : 0])
    );

    // ADD
    alu_add #(.WIDTH(WIDTH)) op_add (
        .x         (x),
        .y         (y),
        .carry_in  (carry_in),
        .z         (t[2 * WIDTH - 1 : WIDTH]),
        .carry_out (overflow)
    );

    // SLL
    alu_sll #(.WIDTH(WIDTH), .SHIFT(SHIFT)) op_sll (
        .x     (x),
        .shamt (shamt),
        .z     (t[3 * WIDTH - 1 : 2 * WIDTH])
    );

    // SLT
    alu_slt #(.WIDTH(WIDTH)) op_slt (
        .x (x),
        .y (y),
        .z (t[4 * WIDTH - 1 : 3 * WIDTH])
    );

    // Mux requested operation result to the output wires
    bn_mux_n1_generate #(.DATA_WIDTH(WIDTH), .SEL_WIDTH(2)) op_mux (
        .data_in  (t),
        .select   (operation),
        .data_out (result)
    );

    // Flags
    assign zero = (result == 0);

endmodule