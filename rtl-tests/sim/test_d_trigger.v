`timescale 1 ns / 100 ps

module testbench;

	reg  clk, d, set_n, rst_n;
	wire q;

	d_trigger d_trigger(clk, d, set_n, rst_n, q);

	initial begin
		d = 0;
		clk = 0;
		rst_n = 1;
		set_n = 1;

		forever #10 clk = !clk;
	end

	initial begin

		$dumpvars;
		$monitor ("%0d clk: %b, d: %b, set: %b, rst_n: %b, q: %b", $time, clk, d, set_n, rst_n, q);

		// check all states
		#50   d = 1;
		#70   d = 0;
		#90   d = 1;
		#110  d = 0;
		#130  d = 1;
		#150  d = 0;
		#170  d = 1;

		// check reset
		#150  rst_n = 0;
		#160  rst_n = 1;

		#200  d = 0;

		// check set
		#250  set_n = 0;
		#260  set_n = 1;

		#500 $finish;
	end
endmodule
