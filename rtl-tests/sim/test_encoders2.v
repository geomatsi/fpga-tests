`timescale 1 ns / 100 ps

`define assert(signal, value)                                        \
	if (signal !== value) begin                                  \
		$display("ASSERTION FAILED in %m: signal != value"); \
		$finish;                                             \
	end

module testbench;

	reg  clock;
	reg  [15:0] di;
	wire [3:0] do;
	wire valid;

	prio_enc_16_4 enc(
		.di    (di[15:0]),
		.do    (do[3:0]),
		.valid (valid)
	);

	initial begin
		clock = 1;

		#20;
		di = 16'b0;
		#2 `assert (valid, 1'b0);

		#20;
		di = 16'b0000000000000001;
		#2 `assert (do, 0);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000000000010;
		#2 `assert (do, 1);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000000000011;
		#2 `assert (do, 1);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b00000000000001xx;
		#2 `assert (do, 2);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000000000110;
		#2 `assert (do, 2);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000000001xxx;
		#2 `assert (do, 3);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000000001010;
		#2 `assert (do, 3);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b000000000001xxxx;
		#2 `assert (do, 4);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000000011010;
		#2 `assert (do, 4);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b00000000001xxxxx;
		#2 `assert (do, 5);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000000101010;
		#2 `assert (do, 5);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000001xxxxxx;
		#2 `assert (do, 6);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000001001010;
		#2 `assert (do, 6);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b000000001xxxxxxx;
		#2 `assert (do, 7);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000010101010;
		#2 `assert (do, 7);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b00000001xxxxxxxx;
		#2 `assert (do, 8);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000000110101010;
		#2 `assert (do, 8);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000001xxxxxxxxx;
		#2 `assert (do, 9);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000001110101010;
		#2 `assert (do, 9);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b000001xxxxxxxxxx;
		#2 `assert (do, 10);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000010110101010;
		#2 `assert (do, 10);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b00001xxxxxxxxxxx;
		#2 `assert (do, 11);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0000110110101010;
		#2 `assert (do, 11);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0001xxxxxxxxxxxx;
		#2 `assert (do, 12);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0001010110101010;
		#2 `assert (do, 12);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b001xxxxxxxxxxxxx;
		#2 `assert (do, 13);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0011010110101010;
		#2 `assert (do, 13);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b01xxxxxxxxxxxxxx;
		#2 `assert (do, 14);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b0101010110101010;
		#2 `assert (do, 14);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b1xxxxxxxxxxxxxxx;
		#2 `assert (do, 15);
		#2 `assert (valid, 1'b1);

		#20;
		di = 16'b1101010110101010;
		#2 `assert (do, 15);
		#2 `assert (valid, 1'b1);

	end

	always #10 clock = ~clock;

	initial
		#1000 $finish;

	initial
		$monitor("clock=%b di=%b do=%d valid=%b",
			clock, di, do, valid);

	initial
		$dumpvars;
endmodule
