module lfsr_example(
    input clk,
    input  [1:0] key,
    output [5:0] led
);

    wire [7:0] leds;
    wire clk_out;
    wire rst_n;

    assign led[5:0] = ~leds[5:0];
    assign rst_n = ~key[1];

    clk_divider #(.DIVISOR(27000000 / 20)) divider(
            .clk_in  (clk),
            .clk_out (clk_out)
    );

    lfsr_fibonacci lfsr(
            .clk   (clk_out),
            .rst_n (rst_n),
            .prnd   (leds)
    );

endmodule

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

module lfsr_fibonacci
(
        input clk,
        input rst_n,
        output reg [7:0] prnd
);

        always @ (posedge clk or negedge rst_n) begin
                if (!rst_n)
                        prnd <= 8'b11111111;
                else
                        prnd = {prnd[6:0], ((prnd[5] ^ prnd[7]) ^ prnd[4]) ^ prnd[3]};
        end
endmodule
