module test_spi_slave_oversampled
(
    input  sysclk,
    
    input  sclk,
    input  cs_n,
    input  mosi,
    output miso,

    output [5:0] leds
);

wire [7:0] data;
wire data_valid;

spi_slave_oversampled spi_block(
    .clk(sysclk),
    .CS_N(cs_n),
    .SCLK(sclk),
    .MOSI(mosi),
    .MISO(miso),

    .data_valid(data_valid),
    .data(data)
);

wire [7:0] command;

control_leds leds_block(
    .clk(sysclk),
    .cmd(command),
    .leds(leds)
);

reg  [7:0] rxbyte;

always @(posedge sysclk) begin
    if (data_valid)
    begin
        rxbyte <= data;
    end
end

assign command = rxbyte;

endmodule