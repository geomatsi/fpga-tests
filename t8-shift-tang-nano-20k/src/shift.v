module left_shifter
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

module left_rotator
#(
    parameter WIDTH = 8,
    parameter SHIFT = 3
)
(
    input  [WIDTH - 1 : 0] x,
    input  [SHIFT - 1 : 0] shamt,
    output [WIDTH - 1 : 0] z
);
    wire [2 * WIDTH - 1 : 0] tmp;
    assign tmp = {x, x} << shamt;
    assign z = tmp[2 * WIDTH - 1 : WIDTH];
endmodule

module right_rotator
#(
    parameter WIDTH = 8,
    parameter SHIFT = 3
)
(
    input  [WIDTH - 1 : 0] x,
    input  [SHIFT - 1 : 0] shamt,
    output [WIDTH - 1 : 0] z
);
    wire [2 * WIDTH - 1 : 0] tmp;
    assign tmp = {x, x} >> shamt;
    assign z = tmp[WIDTH - 1 : 0];
endmodule