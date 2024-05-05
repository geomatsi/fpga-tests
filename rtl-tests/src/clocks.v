module clk_divider
#(
    parameter DIVISOR = 27000000
)
(
    input  clk_in,
    output wire clk_out
);

    reg [32 : 0] cnt = DIVISOR;
    reg out = 0;

    assign clk_out = out;

    always @(posedge clk_in)
    begin
        if (cnt == 0)
            begin
                cnt <= DIVISOR;
                out <= 1'b1;
            end
        else
            begin
                cnt <= cnt - 1'b1;
                out <= 1'b0;
            end
    end

endmodule
