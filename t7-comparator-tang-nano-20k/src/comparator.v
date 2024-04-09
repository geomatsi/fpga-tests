module comparator
#(
    parameter WIDTH = 8
)
(
    input [WIDTH - 1 : 0] x, y,
    output eq, neq, lt, lte, gt, gte
);
    assign lt  = (x < y);
    assign gt  = (x > y);
    assign eq  = (x == y);
    assign neq = (x != y);
    assign lte = (x <= y);
    assign gte = (x >= y);

endmodule