module shift_reg_naive
#(
    parameter WIDTH = 8,
    parameter SHIFT = 3
)
(
    input clock,
    input reset,
    input  [WIDTH - 1 : 0] x,
    input  [SHIFT - 1 : 0] shamt,
    output reg [WIDTH - 1 : 0] z
);

    reg [2 * WIDTH - 1 : 0] tmp;

    always @ (posedge clock)
    begin
        if (reset)
            z <= 1'b1;
        else begin
            tmp = {x, x} << shamt;
            z = tmp[2 * WIDTH - 1 : WIDTH];
        end
    end

endmodule
