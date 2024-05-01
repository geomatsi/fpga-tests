`timescale 1 ns / 100 ps

module testbench;

	reg  clk;
	reg [7:0] bin_in;
	wire [11:0] bcd_out;
	wire [7:0] bin_out;

	bin2bcd decoder(
		.clk     (clk),
		.bin_in  (bin_in),
		.bcd_out (bcd_out),
		.bin_out (bin_out)
	);

	initial begin
		clk = 0;
		bin_in = 8'b000000;

		#20

		// read from mem
		for(bin_in = 0; bin_in < 256; bin_in += 1)
			#20;
	end

	always #10 clk = ~clk;

	initial
		#5200 $finish;

	initial
		$monitor("clk=%b bin_in=%h bcd_out=%h bin_out=%h", clk, bin_in, bcd_out, bin_out);

	initial
		$dumpvars;
endmodule
