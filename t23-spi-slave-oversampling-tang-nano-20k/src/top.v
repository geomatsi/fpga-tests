module test_spi_slave_oversampled
(
    input  sysclk,
    
    input  sclk,
    input  cs_n,
    input  mosi,
    output miso,

    output [5:0] leds
);

wire [7:0] rx_byte;
wire [7:0] tx_byte;
wire data_valid;

spi_slave_oversampled spi_block(
    .clk(sysclk),
    .CS_N(cs_n),
    .SCLK(sclk),
    .MOSI(mosi),
    .MISO(miso),

    .data_valid(data_valid),
    .rx_byte(rx_byte),
    .tx_byte(tx_byte)
);

wire [7:0] command;

control_leds leds_block(
    .clk(sysclk),
    .cmd(command),
    .leds(leds)
);

reg  [7:0] rx_byte_reg;
reg  [7:0] tx_byte_reg;

always @(posedge sysclk) begin
    if (data_valid)
    begin
        tx_byte_reg <= rx_byte;
        rx_byte_reg <= rx_byte;
    end
end

assign command = rx_byte_reg;
assign tx_byte = tx_byte_reg;

endmodule