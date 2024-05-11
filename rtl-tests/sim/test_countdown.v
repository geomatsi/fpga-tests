`timescale 1 ns / 100 ps

module testbench;

	reg [7:0] value;
	reg clk, rst_n;
	wire ready;

	countdown tmr(
		.clk_in (clk),
		.rst_n  (rst_n),
		.value  (value),
		.ready  (ready)
	);

	initial begin
		clk = 0;
		rst_n = 0;
		value = 9;

		#50;

		value = 5;
		rst_n = 0;
		#10;
		rst_n = 1;

		# 150;

		value = 9;
		rst_n = 0;
		#10;
		rst_n = 1;
	end

	always #10 clk = ~clk;

	initial
		#1000 $finish;

	initial
		$monitor("clk=%b rst_n=%b value=%b ready=%b",
				clk, rst_n, value, ready);

	initial
		$dumpvars;

endmodule
