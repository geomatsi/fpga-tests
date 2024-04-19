module counter_example(
    input clk,
    input  [1:0] key,
    output [5:0] led
);
    parameter WIDTH = 6;

    wire [5:0] leds;
    wire clk_out;
    wire rst_n;

    assign led[5:0] = ~leds;
    assign rst_n = ~key[1];

    clk_divider #(.DIVISOR(27000000 / 2)) divider(
            .clk_in  (clk),
            .clk_out (clk_out)
    );

    clk_counter #(.WIDTH(WIDTH)) counter(
            .clk   (clk_out),
            .rst_n (rst_n),
            .cnt   (leds)
    );

endmodule