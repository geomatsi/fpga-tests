`timescale 1 ns / 100 ps

// send several bytes back to back within one CS assertion (mode 0, MSB first)
// and check that each byte is received correctly and in order

module testbench;

	localparam SCLK_HALF = 100;		// SCLK half period: 5 sysclk periods
	localparam NBYTES = 4;

	reg sysclk;

	reg sclk;
	reg cs_n;
	reg miso;
	reg mosi;

	wire data_valid;
	wire [7:0] data;

	reg [7:0] tx_bytes [0:NBYTES-1];
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
	    .data(data)
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
				$display("FAIL: byte %0d: sent 0x%02h, received 0x%02h",
					rx_count, tx_bytes[rx_count], data);
				errors = errors + 1;
			end else begin
				$display("byte %0d: sent 0x%02h, received 0x%02h",
					rx_count, tx_bytes[rx_count], data);
			end
			rx_count = rx_count + 1;
		end
	end

	// mode 0: MOSI changes while SCLK is low, slave samples on rising edge
	task spi_send_byte(input [7:0] b);
		integer j;
		begin
			for (j = 7; j >= 0; j = j - 1) begin
				mosi = b[j];
				#SCLK_HALF sclk = 1;
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

		sysclk = 0;

		sclk = 0;
		cs_n = 1;
		miso = 0;
		mosi = 0;

		rx_count = 0;
		errors = 0;

		#350;
		cs_n = 0;
		#SCLK_HALF;

		// no gaps between bytes: bit counter must wrap 7 -> 0 on its own
		for (i = 0; i < NBYTES; i = i + 1)
			spi_send_byte(tx_bytes[i]);

		#SCLK_HALF;
		cs_n = 1;

		// allow the synchronizer pipeline to catch up
		#200;

		if (rx_count != NBYTES) begin
			$display("FAIL: expected %0d received bytes, got %0d", NBYTES, rx_count);
			errors = errors + 1;
		end

		if (errors == 0)
			$display("PASS: %0d bytes received correctly", NBYTES);
		else
			$display("FAIL: %0d error(s)", errors);

		$finish;
	end

	initial
		$dumpvars;

endmodule // testbench
