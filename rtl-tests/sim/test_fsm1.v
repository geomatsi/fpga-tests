`timescale 1 ns / 100 ps

module testbench;

	reg clock;
	reg reset_n;
	reg enable;
	reg [1:0] a;
	wire [1:0] y;
	wire [1:0] state;

	fsm_test1 fsm1(clock, enable, reset_n, a, y);

	assign state = fsm1.curr_state;

	initial begin
		clock = 1;
		enable = 1;

		reset_n = 0;
		#10;
		reset_n = 1;

		// check where we can go from S0 with fixed input
		a = 2'b00;
		repeat (8) begin
			#20;
		end

		reset_n = 0;
		#50;
		reset_n = 1;

		// check where we can go from S0 with fixed input
		a = 2'b01;
		repeat (8) begin
			#20;
		end

		reset_n = 0;
		#50;
		reset_n = 1;

		// check where we can go from S0 with fixed input
		a = 2'b10;
		repeat (8) begin
			#20;
		end

		reset_n = 0;
		#50;
		reset_n = 1;

		// check where we can go from S0 with fixed input
		a = 2'b11;
		repeat (8) begin
			#20;
		end

		reset_n = 0;
		#50;
		reset_n = 1;
	end

	always #10 clock = ~clock;

	initial
		#1000 $finish;

	initial
		$monitor("clock=%b reset_n=%b enable=%b a=%b y=%b state=%b",
				clock, reset_n, enable, a, y, state);

	initial
		$dumpvars;
endmodule
