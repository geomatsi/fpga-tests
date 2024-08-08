`timescale 1 ns / 100 ps

module testbench;

	reg clock;
	reg reset_n;
	reg arg_valid;
	reg [7 : 0] arg;

	wire [4 : 0] res_valid;
	wire [39 : 0] res;

	pow_5_pipe_always #(.w(8))   pipe_test1(clock, reset_n, arg_valid, arg, res_valid, res);

	initial begin
		clock = 1;
		arg = 8'b0;
		arg_valid = 0;

		reset_n = 0;
		#40;
		reset_n = 1;

		#20;
		arg_valid = 1;
		arg = 40'b10;

		#20;
		arg = 40'b011;

		#20;
		arg = 40'b100;

		#20;
		arg = 40'b101;

		#20;
		arg_valid = 0;
		arg = 40'b000;
	end

	always #10 clock = ~clock;

	initial
		#1000 $finish;

	initial
		$monitor("clock=%b reset_n=%b res_valid=%b res=(%h, %h, %h, %h, %h)",
			clock, reset_n, res_valid, res[39:32], res[31:24], res[23:16], res[15:8], res[7:0]);

	initial
		$dumpvars;
endmodule
