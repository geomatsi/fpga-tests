`timescale 1 ns / 100 ps

// send one byte over SPI (mode 0, MSB first) and check it is received correctly

module testbench;

	localparam SCLK_HALF = 100;		// SCLK half period: 5 sysclk periods
	localparam [7:0] TX_BYTE = 8'hB4;	// 1011_0100: bit-reversed is 0x2D, so bit order errors are caught

	reg sysclk;

	reg sclk;
	reg cs_n;
	reg miso;
	reg mosi;

	wire data_valid;
	wire [7:0] data;

	reg [7:0] rx_byte;
	integer rx_count;

	spi_slave_oversampled spi_block(
	    .clk(sysclk),
	    .CS_N(cs_n),
	    .SCLK(sclk),
	    .MOSI(mosi),
	    .MISO(miso),

	    .data_valid(data_valid),
	    .data(data)
	);

	always #10 sysclk = ~sysclk;

	// data is only valid during the 1-cycle data_valid strobe
	always @(posedge sysclk) begin
		if (data_valid) begin
			rx_byte <= data;
			rx_count <= rx_count + 1;
		end
	end

	// mode 0: MOSI changes while SCLK is low, slave samples on rising edge
	task spi_send_byte(input [7:0] b);
		integer i;
		begin
			for (i = 7; i >= 0; i = i - 1) begin
				mosi = b[i];
				#SCLK_HALF sclk = 1;
				#SCLK_HALF sclk = 0;
			end
		end
	endtask

	initial begin
		sysclk = 0;

		sclk = 0;
		cs_n = 1;
		miso = 0;
		mosi = 0;

		rx_byte = 8'h00;
		rx_count = 0;

		#350;
		cs_n = 0;
		#SCLK_HALF;

		spi_send_byte(TX_BYTE);

		#SCLK_HALF;
		cs_n = 1;

		// allow the synchronizer pipeline to catch up
		#200;

		if (rx_count != 1) begin
			$display("FAIL: expected 1 received byte, got %0d", rx_count);
		end else if (rx_byte !== TX_BYTE) begin
			$display("FAIL: sent 0x%02h, received 0x%02h", TX_BYTE, rx_byte);
		end else begin
			$display("PASS: sent 0x%02h, received 0x%02h", TX_BYTE, rx_byte);
		end

		$finish;
	end

	initial
		$dumpvars;

endmodule // testbench
