`timescale 1 ns / 100 ps

module testbench;

	reg clk;
	reg ena;
	reg [7:0] data;
	wire tx;
	wire done;

	uart_115200_8n1_test uart(
		.clk  (clk),
		.ena  (ena),
		.data (data),
		.tx   (tx),
		.done (done)
	);

	initial begin
		data = 8'b01010101;
		ena = 0;
		clk = 0;

		#60;
		ena = 1;

		#300;
		ena = 0;

		#60;
		data = 8'b00001111;
		ena = 1;

		#300;
		ena = 0;
	end

	always #10 clk = ~clk;

	initial
		#1000 $finish;

	initial
		$monitor("clk=%b ena=%b tx=%b done=%b", clk, ena, tx, done);

	initial
		$dumpvars;

endmodule // testbench
