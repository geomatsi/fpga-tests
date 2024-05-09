`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n, dir;
	wire [1:0] gc1;
	wire [2:0] gc2;

	fsm_test2_gray gray1(
		.clock     (clk),
		.reset_n   (rst_n),
		.direction (dir),
		.gc        (gc1)
	);

	fsm_test3_gray gray2(
		.clock     (clk),
		.reset_n   (rst_n),
		.gc        (gc2)
	);

	initial begin
		clk = 0;

		// forward direction
		dir = 0;

		rst_n = 1;
		#30
		rst_n = 0;
		#30
		rst_n = 1;

		#400;

		// backward direction
		dir = 1;

		rst_n = 1;
		#30
		rst_n = 0;
		#30
		rst_n = 1;
	end

	always #10 clk = ~clk;

	initial
		#800 $finish;

	initial
		$monitor("clk=%b rst_n=%b dir=%b gc1=%b gc2=%b",
				clk, rst_n, dir, gc1, gc2);

	initial
		$dumpvars;

endmodule
