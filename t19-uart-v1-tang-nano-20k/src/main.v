module xmit_test
(
    input clk,
    input  [1:0] key,

    output tx,
    output [5:0] led
);

    wire [7:0] leds;
    wire clk_out;
    wire ena;

    assign led[5:0] = ~leds[5:0];
    assign ena = key[0] | key[1];

    clkdiv #(.BAUDRATE(115200)) uart_clk(
            .clk_in  (clk),
            .clk_out (clk_out)
    );

    uart_115200_8n1_v1 uart_xmit(
        .clk (clk_out),
        .ena (ena),
        .data (8'b01000001),
        .tx   (tx),
        .done (leds[0])
    );

endmodule

