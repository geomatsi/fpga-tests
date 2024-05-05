`timescale 1 ns / 100 ps

module testbench;

parameter DIV3 = 3;
parameter DIV10 = 10;

	wire clk_out3, clk_out10;
	reg clk_in;

	clk_divider #(.DIVISOR(DIV3)) div3(
		.clk_in  (clk_in),
		.clk_out (clk_out3)
	);

	clk_divider #(.DIVISOR(DIV10)) div10(
		.clk_in  (clk_in),
		.clk_out (clk_out10)
	);

	initial
		clk_in = 0;

	always #10 clk_in = ~clk_in;

	initial
		#500 $finish;

	initial
		$monitor("clk_in=%b clk_out3=%b clk_out10=%b", clk_in, clk_out3, clk_out10);

	initial
		$dumpvars;

endmodule
