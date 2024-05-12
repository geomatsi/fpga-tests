`timescale 1 ns / 100 ps

module testbench;

	reg clk, rst_n, detect;
	wire red, yellow, green;

	traffic_light_v1 #(.RED_DURATION(4), .GREEN_DURATION(6)) tlv1(
		.clk_in (clk),
		.detect (detect),
		.rst_n  (rst_n),
		.red    (red),
		.yellow (yellow),
		.green  (green)
	);

	initial begin
		clk = 0;
		rst_n = 0;
		detect = 0;

		#20;

		rst_n = 1;
	end

	always #10 clk = ~clk;

	initial
		#2000 $finish;

	initial
		$monitor("clk=%b rst_n=%b detect=%b red=%b yellow=%b green=%b ready=%b",
				clk, rst_n, detect, red, yellow, green, tlv1.tmr_ready);

	initial
		$dumpvars;

endmodule
