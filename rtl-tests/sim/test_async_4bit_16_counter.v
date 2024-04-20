`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n;
	wire [3:0] out;

	async_4bit_16_counter c(
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

		#100   rst_n = 1;
		#1000  rst_n = 0;
		#1100  rst_n = 1;

		#2000 $finish;
	end
endmodule
