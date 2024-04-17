module counter_example(
    input  [1:0] key,
    output [5:0] led
);
    parameter WIDTH = 6;

    wire [5:0] leds;
    wire clk;
    wire rst_n;

    assign led[5:0] = ~leds;
    assign rst_n = ~key[1];
    assign clk = key[0];

    simple_counter #(.WIDTH(WIDTH)) counter(
            .clk   (clk),
            .rst_n (rst_n),
            .cnt   (leds)
    );

endmodule