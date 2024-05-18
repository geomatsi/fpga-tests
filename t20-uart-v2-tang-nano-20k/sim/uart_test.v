`timescale 1 ns / 100 ps

module testbench;

	reg  clk;
	reg  [1:0] key;
	wire tx;
	wire [5:0] leds;

	xmit_test #(.MAIN(5), .BAUD(5), .SLOW(1)) t(
		.clk  (clk),
		.key  (key),
		.tx   (tx),
		.led  (leds)
	);

	initial begin
		key = 2'b00;
		clk = 0;
	end

	always #10 clk = ~clk;

	initial
		#2000 $finish;

	initial
		$monitor("clk=%b tx=%b", clk, tx);

	initial
		$dumpvars;

endmodule // testbench
