`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n, en;
	reg [3:0] pipo_4_in;
	wire [3:0] pipo_4_out;

	ring_sipo_4bit r1(
		.clk   (clk & en),
		.p_in  (pipo_4_in),
		.rst_n (rst_n),
		.p_out (pipo_4_out)
	);

	initial begin
		en = 1;
		clk = 0;
		rst_n = 0;
		pipo_4_in = 4'b0000;

		forever #10 clk = !clk;
	end

	initial begin
		$dumpvars;
		$monitor ("Time: %g, clk: %b, rst_n: %b, in: %b, out: %b", $time, clk, rst_n, pipo_4_in, pipo_4_out);

		#100 en = 0; // stop clocking sipo
		#10  rst_n = 1;
		#10  pipo_4_in = 4'b0100;
		#10  pipo_4_in = 4'b0000;
		#10  en = 1; // continue clocking


		#300 en = 0;
		#10  rst_n = 0;
		#10  rst_n = 1;
		#10  pipo_4_in = 4'b1011;
		#10  pipo_4_in = 4'b0000;
		#10  en = 1;

		#1000 $finish;
	end
endmodule
