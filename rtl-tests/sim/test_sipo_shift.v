`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n, s_in;
	wire [3:0] sipo_4_out;

	shift_sipo_4bit s1(
		.clk   (clk),
		.s_in  (s_in),
		.rst_n (rst_n),
		.p_out (sipo_4_out)
	);

	initial begin
		clk = 0;
		rst_n = 0;
		forever #10 clk = !clk;
	end

	initial forever begin
		#20;
		s_in = $urandom_range(0, 1);
	end

	initial begin
		$dumpvars;
		$monitor ("Time: %0d, clk: %b, rst_n: %b, in: %b, out: %b", $time, clk, rst_n, s_in, sipo_4_out);

		#100   rst_n = 1;
		#1000  rst_n = 0;
		#1100  rst_n = 1;

		#2000 $finish;
	end
endmodule
