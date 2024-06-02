`timescale 1 ns / 100 ps

`define assert(signal, value)                                        \
	if (signal !== value) begin                                  \
		$display("ASSERTION FAILED in %m: signal != value"); \
		$finish;                                             \
	end

module testbench;

	reg x, y, z;
	reg  clock;
	reg  [4:0] a;
	reg  [4:0] b;
	wire gt;
	wire eq;
	wire lt;

	cmp_4bit_cascaded c1(
		.a  (a[3:0]),
		.b  (b[3:0]),
		.gt (gt),
		.eq (eq),
		.lt (lt)
	);

	initial begin
		clock = 1;

		#20;
		a = 4'b0000;
		b = 4'b0000;
		#2 `assert (gt, 1'b0);
		#2 `assert (eq, 1'b1);
		#2 `assert (lt, 1'b0);

		#20;
		a = 4'b0001;
		b = 4'b0000;
		#2 `assert (gt, 1'b1);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b0);

		#20;
		a = 4'b0000;
		b = 4'b0001;
		#2 `assert (gt, 1'b0);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b1);

		#20;
		a = 4'b1xxx;
		b = 4'b0xxx;
		#2 `assert (gt, 1'b1);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b0);

		a = 4'b0xxx;
		b = 4'b1xxx;
		#2 `assert (gt, 1'b0);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b1);

		for(a = 0; a < 2 ** 4; a = a + 1) begin
			for(b = 0; b < 2 ** 4; b = b + 1) begin
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
		#7000 $finish;

	initial
		$monitor("clock=%b a=%b b=%b gt=%b eq=%b lt=%b x=%b y=%b z=%b",
			clock, a, b, gt, eq, lt, x, y, z);

	initial
		$dumpvars;
endmodule
