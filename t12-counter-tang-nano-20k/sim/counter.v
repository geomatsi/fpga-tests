`timescale 1 ns / 100 ps

module testbench;

parameter WIDTH = 4;

	wire [WIDTH - 1 : 0] cnt;
	reg rst_n;
	reg clk;

	simple_counter #(.WIDTH(WIDTH)) cnt1(
		.cnt    ( cnt   ),
		.clk    ( clk   ),
		.rst_n  ( rst_n )
	);
   
	//clock generation
	initial begin
		clk = 0;
		forever #10 clk = !clk;
	end

	initial begin
		$dumpvars;
		$monitor("@time=%0t\t cnt=0x%h\n",$time,cnt);
		$monitor ("Time: %g, clk: %b, rst_n: %b, cnt: %b", $time, clk, rst_n, cnt);

		rst_n     = 1;
		#10 rst_n = 0;
		#20 rst_n = 1;
		#200 rst_n = 0;
		#220 rst_n = 1;

		#1000 $finish;
	end
endmodule // testbench
