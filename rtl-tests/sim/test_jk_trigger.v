`timescale 1 ns / 100 ps

module testbench;

	reg  clk, j, k, rst_n;
	wire q;

	jk_trigger jk_trigger(clk, j, k, rst_n, q);

	initial begin
		rst_n = 1;
		clk = 0;
		j = 1;
		k = 0;
		forever #10 clk = !clk;
	end

	initial begin

		$dumpvars;
		$monitor ("%0d clk %b rst_n %b j %b k %b q %b", $time, clk, rst_n, j, k, q);

		// check all states
		#10   j = 1; k = 0;
		#50   j = 0; k = 0;
		#90   j = 0; k = 1;
		#130  j = 0; k = 0;
		#170  j = 1; k = 1;

		// keep j = k = 1: check switch mode

		// check reset
		#250  rst_n = 0;
		#300  rst_n = 1;

		// keep j = k = 1: check switch mode

		#500 $finish;
    	end
endmodule
