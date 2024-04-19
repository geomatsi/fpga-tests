module pwm
#(
    parameter DIVISOR = 27000000,
    parameter DUTY = 27000000 / 2
)
(
    input  clk_in,
    output wire clk_out
);

    reg [32 : 0] cnt = 0;
    reg out = 1'b1;

    assign clk_out = out;

    always @(posedge clk_in)
    begin
        if (cnt == DIVISOR)
            begin
                cnt <= 0;
                out <= 1'b1;
            end
        else
            begin
                cnt <= cnt + 1'b1;
                if (cnt > DUTY)
                    out <= 1'b0;
            end
    end

endmodule