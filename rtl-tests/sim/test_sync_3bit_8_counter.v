`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n;
	wire [2:0] out;

	sync_3bit_8_counter c(
		.clk   (clk),
		.rst_n (rst_n),
		.out   (out)
	);

	initial begin
		clk = 0;
		rst_n = 0;
		forever #10 clk = !clk;
	end

	initial begin
		$dumpvars;
		$monitor ("Time: %0d, clk: %b, out: %b", $time, clk, out);

		#50  rst_n = 1;

		#500 $finish;
	end
endmodule
