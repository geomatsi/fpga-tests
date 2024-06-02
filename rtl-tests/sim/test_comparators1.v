`timescale 1 ns / 100 ps

`define assert(signal, value)                                        \
	if (signal !== value) begin                                  \
		$display("ASSERTION FAILED in %m: signal != value"); \
		$finish;                                             \
	end

module testbench;

	reg  clock;
	reg  [1:0] a;
	reg  [1:0] b;
	wire gt;
	wire eq;
	wire lt;

	cmp_2bit c1(
		.a  (a),
		.b  (b),
		.gt (gt),
		.eq (eq),
		.lt (lt)
	);

	initial begin
		clock = 1;

		#20;
		a = 2'b00;
		b = 2'b00;
		#2 `assert (gt, 1'b0);
		#2 `assert (eq, 1'b1);
		#2 `assert (lt, 1'b0);

		#20;
		a = 2'b01;
		b = 2'b00;
		#2 `assert (gt, 1'b1);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b0);

		#20;
		a = 2'b00;
		b = 2'b01;
		#2 `assert (gt, 1'b0);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b1);

		#20;
		a = 2'b11;
		b = 2'b11;
		#2 `assert (gt, 1'b0);
		#2 `assert (eq, 1'b1);
		#2 `assert (lt, 1'b0);

		#20;
		a = 2'b1x;
		b = 2'b0x;
		#2 `assert (gt, 1'b1);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b0);

		#20;
		a = 2'b0x;
		b = 2'b1x;
		#2 `assert (gt, 1'b0);
		#2 `assert (eq, 1'b0);
		#2 `assert (lt, 1'b1);
	end

	always #10 clock = ~clock;

	initial
		#500 $finish;

	initial
		$monitor("clock=%b a=%b b=%b gt=%b eq=%b lt=%b",
			clock, a, b, gt, eq, lt);

	initial
		$dumpvars;
endmodule
