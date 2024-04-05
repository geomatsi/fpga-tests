module jk_trigger
(
    input clk,
    input j,
    input k,
    output reg q
);

always @ (posedge clk)
begin
    if (j && k)
        q <= ~q;
    else if (j && ~k)
        q <= 1;
    else if (~j && k)
        q <= 0;
end
endmodule