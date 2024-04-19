`timescale 1 ns / 100 ps

module testbench;

	wire clk_out10;
	wire clk_out20;
	wire clk_out40;
	reg clk_in;

	pwm #(.DIVISOR(50), .DUTY(10)) pwm_10(
		.clk_in  (clk_in),
		.clk_out (clk_out10)
	);

	pwm #(.DIVISOR(50), .DUTY(20)) pwm_20(
		.clk_in  (clk_in),
		.clk_out (clk_out20)
	);

	pwm #(.DIVISOR(50), .DUTY(40)) pwm_40(
		.clk_in  (clk_in),
		.clk_out (clk_out40)
	);

	initial begin
		clk_in = 0;
		forever #10 clk_in = !clk_in;
	end

	initial begin
		$dumpvars;
		$monitor ("Time: %g, clk_in: %b, clk_out10: %b, clk_out20: %b, clk_out40: %b", $time, clk_in, clk_out10, clk_out20, clk_out40);

		#5000 $finish;
	end
endmodule // testbench
