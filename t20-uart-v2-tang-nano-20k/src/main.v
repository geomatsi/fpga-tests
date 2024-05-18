module xmit_test
#(
    parameter MAIN = 27000000,
    parameter BAUD = 115200,
    parameter SLOW = 10
)
(
    input  [1:0] key,
    input clk,

    output tx,
    output [5:0] led
);

    wire [3:0] addr_leds;

    wire clk_uart;
    wire done;
    reg [3:0] addr = 4'b0000;
    reg xmit = 1'b0;

    wire [7:0] romdata;
    reg [7:0] char;

    wire [7:0] tmr_current;
    wire clk_timer;
    wire tmr_ready;
    reg [7:0] tmr_val = 8'b00000000;
    reg tmr_rst_n = 1'b0;

    assign rst_n = ~key[0] & ~key[1];
    assign led[3:0] = ~addr_leds[3:0];
    assign led[4] = 1'b1;
    assign led[5] = 1'b1;

    clkdiv #(.OSC(MAIN), .OUT(BAUD)) uart_clk(
            .clk_in  (clk),
            .clk_out (clk_uart)
    );

    clkdiv #(.OSC(MAIN), .OUT(SLOW)) timer_clk(
            .clk_in  (clk),
            .clk_out (clk_timer)
    );

    counter timer(
        .value   (tmr_val),
        .clk_in  (clk_timer),
        .rst_n   (tmr_rst_n),
        .ready   (tmr_ready),
        .current (tmr_current)
    );

    sprom #(.DATA_WIDTH(8), .ADDR_WIDTH(4)) rom(
        .clk(clk),
        .addr_in(addr),
        .addr_out (addr_leds[3:0]),
        .data_out (romdata)
    );

    uart_115200_8n1_test uart_xmit(
        .clk  (clk_uart),
        .ena  (xmit),
        .data (char),
        .tx   (tx),
        .done (done)
    );

    always @(posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            begin
                addr <= 4'b0000;
                xmit <= 1'b0;

                tmr_rst_n <= 1'b0; 
                tmr_val <= 1;
            end
        else
            if (done)
                begin
                    addr <= addr + 1'b1;
                    char <= romdata;
                    xmit <= 1'b0;

                    tmr_rst_n <= 1'b1; 
                    tmr_val <= 2;
                end
            else if (tmr_ready)
                begin
                    tmr_rst_n <= 1'b0;
                    tmr_val <= 0;
                    xmit <= 1'b1;
                end
            else
                tmr_rst_n <= 1'b1;
    end

endmodule
