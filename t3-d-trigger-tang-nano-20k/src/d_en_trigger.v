module d_en_trigger
(
    input clk,
    input en,
    input d,
    output reg q
);

always @ (posedge clk)
begin
    if (en)
        q <= d;
end
endmodule