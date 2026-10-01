`timescale 1 ns / 100 ps

// exchange several bytes back to back within one CS assertion (mode 0, MSB first)
// and check that each byte is received correctly and in order in both directions:
// slave TX data is reloaded on every data_valid strobe, as top.v does

module testbench;

	localparam SCLK_HALF = 100;		// SCLK half period: 5 sysclk periods
	localparam NBYTES = 4;

	reg sysclk;

	reg sclk;
	reg cs_n;
	reg mosi;
	wire miso;

	wire data_valid;
	wire [7:0] data;
	reg  [7:0] tx_byte;

	reg [7:0] tx_bytes [0:NBYTES-1];	// master -> slave
	reg [7:0] slv_bytes [0:NBYTES-1];	// slave -> master
	reg [7:0] miso_byte;
	integer rx_count;
	integer errors;
	integer i;

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

	// data is only valid during the 1-cycle data_valid strobe:
	// compare each received byte against the expected one in order
	always @(posedge sysclk) begin
		if (data_valid) begin
			if (rx_count >= NBYTES) begin
				$display("FAIL: unexpected extra byte 0x%02h", data);
				errors = errors + 1;
			end else if (data !== tx_bytes[rx_count]) begin
				$display("FAIL: MOSI byte %0d: sent 0x%02h, received 0x%02h",
					rx_count, tx_bytes[rx_count], data);
				errors = errors + 1;
			end else begin
				$display("MOSI byte %0d: sent 0x%02h, received 0x%02h",
					rx_count, tx_bytes[rx_count], data);
			end
			rx_count = rx_count + 1;

			// next byte for the slave to send: it must be ready by the
			// SCLK falling edge that follows the last bit of this byte
			if (rx_count < NBYTES)
				tx_byte <= slv_bytes[rx_count];
		end
	end

	// mode 0: MOSI/MISO change while SCLK is low, both sides sample on rising edge
	task spi_xfer_byte(input [7:0] b, output [7:0] r);
		integer j;
		begin
			for (j = 7; j >= 0; j = j - 1) begin
				mosi = b[j];
				#SCLK_HALF sclk = 1;
				r[j] = miso;
				#SCLK_HALF sclk = 0;
			end
		end
	endtask

	initial begin
		// asymmetric patterns catch bit order errors, 0x00/0xFF catch stuck bits,
		// 0x00 -> 0xFF -> 0x1E flip MOSI right at byte boundaries to catch bit leakage
		tx_bytes[0] = 8'hB4;
		tx_bytes[1] = 8'h00;
		tx_bytes[2] = 8'hFF;
		tx_bytes[3] = 8'h1E;

		// same idea for MISO, but different values so the directions can't mask each other
		slv_bytes[0] = 8'hC6;
		slv_bytes[1] = 8'hFF;
		slv_bytes[2] = 8'h00;
		slv_bytes[3] = 8'h3A;

		sysclk = 0;

		sclk = 0;
		cs_n = 1;
		mosi = 0;

		tx_byte = slv_bytes[0];

		rx_count = 0;
		errors = 0;

		#350;
		cs_n = 0;
		#SCLK_HALF;

		// no gaps between bytes: bit counter must wrap 7 -> 0 on its own
		for (i = 0; i < NBYTES; i = i + 1) begin
			spi_xfer_byte(tx_bytes[i], miso_byte);
			if (miso_byte !== slv_bytes[i]) begin
				$display("FAIL: MISO byte %0d: sent 0x%02h, received 0x%02h",
					i, slv_bytes[i], miso_byte);
				errors = errors + 1;
			end else begin
				$display("MISO byte %0d: sent 0x%02h, received 0x%02h",
					i, slv_bytes[i], miso_byte);
			end
		end

		#SCLK_HALF;
		cs_n = 1;

		// allow the synchronizer pipeline to catch up
		#200;

		if (rx_count != NBYTES) begin
			$display("FAIL: expected %0d received bytes, got %0d", NBYTES, rx_count);
			errors = errors + 1;
		end

		if (errors == 0)
			$display("PASS: %0d bytes exchanged correctly", NBYTES);
		else
			$display("FAIL: %0d error(s)", errors);

		$finish;
	end

	initial
		$dumpvars;

endmodule // testbench
