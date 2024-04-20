`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n;
	wire [3:0] upcount, downcount;

	async_4bit_16_counter c_up(
		.clk   (clk),
		.dir   (1'b1),
		.rst_n (rst_n),
		.out   (upcount)
	);

	async_4bit_16_counter c_down(
		.clk   (clk),
		.dir   (1'b0),
		.rst_n (rst_n),
		.out   (downcount)
	);

	initial begin
		clk = 0;
		rst_n = 0;
		forever #10 clk = !clk;
	end

	initial begin
		$dumpvars;
		$monitor ("Time: %0d, clk: %b, up: %b, down: %b", $time, clk, upcount, downcount);

		#100   rst_n = 1;
		#1000  rst_n = 0;
		#1100  rst_n = 1;

		#2000 $finish;
	end
endmodule
