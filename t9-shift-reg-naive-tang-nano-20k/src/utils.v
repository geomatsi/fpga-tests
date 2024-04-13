module unit_delay
#(
    parameter WIDTH = 8
)
(
    input clock,
    input [WIDTH - 1 : 0] d_in,
    output reg [WIDTH - 1 : 0] d_out
);
    always @ (negedge clock)
        d_out <= d_in;
endmodule
    