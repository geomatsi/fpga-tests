module counter
(
    input [7:0] value,
    input clk_in,
    input rst_n,

    output [7:0] current,
    output ready
);
    reg [7:0] cnt = 8'b0;
    reg out = 0;

    assign current = cnt;
    assign ready = out;

    always @(posedge clk_in or negedge rst_n)
    begin
        if (!rst_n)
            begin
                cnt <= value;
                out <= 1'b0;
            end
        else if (cnt == 0)
            out <= 1'b1;
        else
            cnt <= cnt - 1'b1;
    end

endmodule
