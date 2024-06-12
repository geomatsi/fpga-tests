module xmit_test
(
    input rx,
    input clk,
    input [1:0] key,

    output tx,
    output [5:0] led
);

    wire [7:0] leds;
    wire clk_out;
    wire enable;
    wire error;
    wire done;

    assign enable = key[0] | key[1];
    assign led[3:0] = ~leds[3:0];
    assign led[4] = ~done;
    assign led[5] = ~error;

    clkdiv #(.BAUDRATE(115200)) uart_clk(
            .clk_in  (clk),
            .clk_out (clk_out)
    );

    uart_115200_8n1_v2_rx uart_recv(
        .rx     (rx),
        .clock  (clk_out),
        .enable (enable),
        .done   (done),
        .error  (error),
        .data   (leds)
    );

endmodule

