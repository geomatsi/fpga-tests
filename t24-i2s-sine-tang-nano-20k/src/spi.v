// oversampled SPI slave, everything in system clk domain

module spi_slave_oversampled(
    input   clk,

    input   CS_N,
    input   SCLK,
    input   MOSI,
    output  MISO,

    output  [7:0] rx_byte,
    input   [7:0] tx_byte,
    output        data_valid
);

reg [2:0] sclk_sync, mosi_sync, cs_sync;

always @(posedge clk) begin
    sclk_sync <= {sclk_sync[1:0], SCLK};
    mosi_sync <= {mosi_sync[1:0], MOSI};
    cs_sync   <= {cs_sync[1:0],   CS_N};
end

wire sclk_rise = (sclk_sync[2:1] == 2'b01);
wire sclk_fall = (sclk_sync[2:1] == 2'b10);
wire cs_active = ~cs_sync[1];

reg [7:0] shreg;
reg [7:0] tx_shreg;
reg [3:0] bitcnt;

reg [7:0] rx_byte_reg;
reg       byte_valid;

always @(posedge clk) begin

    byte_valid <= 1'b0;
    rx_byte_reg <= 8'b0;

    if (!cs_active) begin
        bitcnt   <= 0;
        tx_shreg <= tx_byte;                    // MSB is on MISO before the first rising edge
    end else begin
        // Mode 0: sample on rising and shift on falling
        if (sclk_rise) begin
            shreg  <= {shreg[6:0], mosi_sync[1]};

            if (bitcnt == 4'd7) begin
                bitcnt     <= 0;
                rx_byte_reg    <= {shreg[6:0], mosi_sync[1]};
                byte_valid <= 1'b1;             // 1-cycle strobe, already in clk domain
            end else begin
                bitcnt <= bitcnt + 1'b1;
            end
        end

        if (sclk_fall) begin
            if (bitcnt == 0)
                tx_shreg <= tx_byte;            // falling edge after the last bit: load the next byte
            else
                tx_shreg <= {tx_shreg[6:0], 1'b0};
        end
    end
end

assign data_valid = byte_valid;
assign rx_byte = rx_byte_reg;
// output enable straight from the pin: no need to wait for the synchronizer
assign MISO = CS_N ? 1'bz : tx_shreg[7];

endmodule