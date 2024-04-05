module d_latch
(
    input clk,
    input d,
    output reg q
);

always @ (clk or d)
begin
    if (clk)
        q <= d;
end
endmodule