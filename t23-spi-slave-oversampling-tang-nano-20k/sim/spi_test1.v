`timescale 1 ns / 100 ps

module testbench;

	reg sysclk;

	reg sclk;
	reg cs_n;
	reg miso;
	reg mosi;

	wire data_valid;
	wire [7:0] data;

	spi_slave_oversampled spi_block(
	    .clk(sysclk),
	    .CS_N(cs_n),
	    .SCLK(sclk),
	    .MOSI(mosi),
	    .MISO(miso),
	
	    .data_valid(data_valid),
	    .data(data)
	);

	initial begin
		sysclk = 0;

		sclk = 0;
		cs_n = 1;
		miso = 0;
		mosi = 0;

		#350;
		cs_n = 0;

		#1600;
		cs_n = 1;
	end

	always #10 sysclk = ~sysclk;
	always #100 sclk  = ~sclk;

	always @(negedge sclk) begin
		mosi = ~mosi;	
	end

	initial
		#5000 $finish;

	initial
		$dumpvars;

endmodule // testbench
