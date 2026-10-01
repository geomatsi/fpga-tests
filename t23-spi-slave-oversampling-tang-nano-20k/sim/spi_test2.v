`timescale 1 ns / 100 ps

// exchange one byte over SPI (mode 0, MSB first) and check that the byte is
// received correctly by the slave (MOSI) and by the master (MISO)

module testbench;

	localparam SCLK_HALF = 100;		// SCLK half period: 5 sysclk periods
	localparam [7:0] TX_BYTE = 8'hB4;	// master -> slave, 1011_0100: bit-reversed is 0x2D, so bit order errors are caught
	localparam [7:0] SLV_BYTE = 8'hC6;	// slave -> master, 1100_0110: bit-reversed is 0x63

	reg sysclk;

	reg sclk;
	reg cs_n;
	reg mosi;
	wire miso;

	wire data_valid;
	wire [7:0] data;
	reg  [7:0] tx_byte;

	reg [7:0] rx_byte;
	reg [7:0] miso_byte;
	integer rx_count;
	integer errors;

	spi_slave_oversampled spi_block(
	    .clk(sysclk),
	    .CS_N(cs_n),
	    .SCLK(sclk),
	    .MOSI(mosi),
	    .MISO(miso),

	    .data_valid(data_valid),
	    .rx_byte(data),
	    .tx_byte(tx_byte)
	);

	always #10 sysclk = ~sysclk;

	// data is only valid during the 1-cycle data_valid strobe
	always @(posedge sysclk) begin
		if (data_valid) begin
			rx_byte <= data;
			rx_count <= rx_count + 1;
		end
	end

	// mode 0: MOSI/MISO change while SCLK is low, both sides sample on rising edge
	task spi_xfer_byte(input [7:0] b, output [7:0] r);
		integer i;
		begin
			for (i = 7; i >= 0; i = i - 1) begin
				mosi = b[i];
				#SCLK_HALF sclk = 1;
				r[i] = miso;
				#SCLK_HALF sclk = 0;
			end
		end
	endtask

	// MISO must be released (Hi-Z) while CS is high
	task check_miso_z(input [8*16-1:0] when);
		begin
			if (miso !== 1'bz) begin
				$display("FAIL: MISO is not Hi-Z %0s: %b", when, miso);
				errors = errors + 1;
			end else begin
				$display("MISO is Hi-Z %0s", when);
			end
		end
	endtask

	initial begin
		sysclk = 0;

		sclk = 0;
		cs_n = 1;
		mosi = 0;

		tx_byte = SLV_BYTE;

		rx_byte = 8'h00;
		miso_byte = 8'h00;
		rx_count = 0;
		errors = 0;

		#350;
		check_miso_z("before CS low");
		cs_n = 0;
		#1;
		if (miso === 1'bz || miso === 1'bx) begin
			$display("FAIL: MISO is not driven after CS low: %b", miso);
			errors = errors + 1;
		end
		#(SCLK_HALF - 1);

		spi_xfer_byte(TX_BYTE, miso_byte);

		#SCLK_HALF;
		cs_n = 1;
		#1;
		check_miso_z("after CS high");

		// allow the synchronizer pipeline to catch up
		#200;

		if (rx_count != 1) begin
			$display("FAIL: expected 1 received byte, got %0d", rx_count);
			errors = errors + 1;
		end else if (rx_byte !== TX_BYTE) begin
			$display("FAIL: MOSI: sent 0x%02h, received 0x%02h", TX_BYTE, rx_byte);
			errors = errors + 1;
		end else begin
			$display("MOSI: sent 0x%02h, received 0x%02h", TX_BYTE, rx_byte);
		end

		if (miso_byte !== SLV_BYTE) begin
			$display("FAIL: MISO: sent 0x%02h, received 0x%02h", SLV_BYTE, miso_byte);
			errors = errors + 1;
		end else begin
			$display("MISO: sent 0x%02h, received 0x%02h", SLV_BYTE, miso_byte);
		end

		if (errors == 0)
			$display("PASS");
		else
			$display("FAIL: %0d error(s)", errors);

		$finish;
	end

	initial
		$dumpvars;

endmodule // testbench
