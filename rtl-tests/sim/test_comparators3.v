`timescale 1 ns / 100 ps

`define assert(signal, value)                                        \
	if (signal !== value) begin                                  \
		$display("ASSERTION FAILED in %m: signal != value"); \
		$finish;                                             \
	end

module testbench;

	reg x, y, z;
	reg  clock;
	reg  [8:0] a;
	reg  [8:0] b;
	wire gt;
	wire eq;
	wire lt;

	cmp_8bit_cascaded c1(
		.a  (a[7:0]),
		.b  (b[7:0]),
		.gt (gt),
		.eq (eq),
		.lt (lt)
	);

	initial begin
		clock = 1;

		for(a = 0; a < 2 ** 8; a += 1) begin
			for(b = 0; b < 2 ** 8; b += 1) begin
				#20;
				x = a >  b;
				y = a == b;
				z = a <  b;
				#2 `assert (gt, x);
				#2 `assert (eq, y);
				#2 `assert (lt, z);
			end
		end
	end

	always #10 clock = ~clock;

	initial
		#1800000 $finish;

	initial
		$monitor("clock=%b a=%b b=%b gt=%b eq=%b lt=%b x=%b y=%b z=%b",
			clock, a, b, gt, eq, lt, x, y, z);

	initial
		$dumpvars;
endmodule
