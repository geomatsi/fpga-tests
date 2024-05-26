`timescale 1 ns / 100 ps

`define assert(signal, value)                                        \
	if (signal !== value) begin                                  \
		$display("ASSERTION FAILED in %m: signal != value"); \
		$finish;                                             \
	end

module testbench;

	reg  clock;
	reg  [3:0] di;
	wire [1:0] do;
	wire valid;

	prio_enc_4_2 enc(
		.di    (di[3:0]),
		.do    (do[1:0]),
		.valid (valid)
	);

	initial begin
		clock = 1;

		#20;
		di = 4'b0000;
		#2 `assert (valid, 1'b0);

		#20;
		di = 4'b0001;
		#2 `assert (do, 2'b00);
		#2 `assert (valid, 1'b1);

		#20;
		di = 4'b0010;
		#2 `assert (do, 2'b01);
		#2 `assert (valid, 1'b1);

		#20;
		di = 4'b0011;
		#2 `assert (do, 2'b01);
		#2 `assert (valid, 1'b1);

		#20;
		di = 4'b0100;
		#2 `assert (do, 2'b10);
		#2 `assert (valid, 1'b1);

		#20;
		di = 4'b0101;
		#2 `assert (do, 2'b10);
		#2 `assert (valid, 1'b1);

		#20;
		di = 4'b0110;
		#2 `assert (do, 2'b10);
		#2 `assert (valid, 1'b1);


		#20;
		di = 4'b0111;
		#2 `assert (do, 2'b10);
		#2 `assert (valid, 1'b1);

		#20;
		di = 4'b1xxx;
		#2 `assert (do, 2'b11);
		#2 `assert (valid, 1'b1);

	end

	always #10 clock = ~clock;

	initial
		#500 $finish;

	initial
		$monitor("clock=%b di=%b do=%b valid=%b",
			clock, di, do, valid);

	initial
		$dumpvars;
endmodule
