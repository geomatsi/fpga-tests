`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n;
	wire [7:0] rnd1;
	wire [3:0] rnd2;
	wire [3:0] rnd3;

	lfsr_fibonacci lfsr1(
		.clk   (clk),
		.rst_n (rst_n),
		.prnd  (rnd1)
	);

	lfsr_simple lfsr2(
		.clk   (clk),
		.rst_n (rst_n),
		.prnd  (rnd2)
	);

	lfsr_simple_rtl lfsr3(
		.clk   (clk),
		.rst_n (rst_n),
		.prnd  (rnd3)
	);

	initial begin
		clk = 0;
		rst_n = 0;
		forever #10 clk = !clk;
	end

	initial begin
		$dumpvars;
		$monitor ("Time: %0d, clk: %b, rst_n: %b, prnd1: %b, prnd2: %b, prnd3: %b", $time, clk, rst_n, rnd1, rnd2, rnd3);

		#10   rst_n = 1;
		#200  rst_n = 0;
		#10   rst_n = 1;

		#2000 $finish;
	end
endmodule
