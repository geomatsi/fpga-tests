`timescale 1 ns / 100 ps

module testbench;

parameter DIVISOR = 5;
parameter WIDTH   = 4;

	wire [WIDTH - 1 : 0] cnt;
	wire clk_out;
	reg clk_in;
	reg rst_n;

	clk_divider #(.DIVISOR(DIVISOR)) divider(
		.clk_in  (clk_in),
		.clk_out (clk_out)
	);

	clk_counter #(.WIDTH(WIDTH)) counter(
		.cnt    (cnt),
		.clk    (clk_out),
		.rst_n  (rst_n)
	);
   
	initial begin
		clk_in = 0;
		forever #10 clk_in = !clk_in;
	end

	initial begin
		$dumpvars;
		$monitor("@time=%0t\t cnt=0x%h\n",$time,cnt);
		$monitor ("Time: %g, clk_in: %b, clk_out: %b, rst_n: %b, cnt: %b", $time, clk_in, clk_out, rst_n, cnt);

		rst_n     = 1;
		#10 rst_n = 0;
		#20 rst_n = 1;
		#200 rst_n = 0;
		#220 rst_n = 1;

		#1000 $finish;
	end
endmodule // testbench
