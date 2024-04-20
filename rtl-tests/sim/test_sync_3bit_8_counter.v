`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n;
	wire [2:0] count_up;

	sync_3bit_8_counter c_up(
		.clk   (clk),
		.rst_n (rst_n),
		.out   (count_up)
	);

	initial begin
		clk = 0;
		rst_n = 0;
		forever #10 clk = !clk;
	end

	initial begin
		$dumpvars;
		$monitor ("Time: %0d, clk: %b, up: %b", $time, clk, count_up);

		#50   rst_n = 1;
		#200  rst_n = 0;
		#250  rst_n = 1;

		#500 $finish;
	end
endmodule
