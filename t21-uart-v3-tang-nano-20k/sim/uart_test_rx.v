`timescale 1 ns / 100 ps

module testbench;

	reg rx;
	reg clock;
	reg enable;

	wire done;
	wire error;
	wire [7:0] data;

	uart_115200_8n1_v2_rx uart_rx(
		.rx     (rx),
		.clock  (clock),
		.enable (enable),
		.done   (done),
		.error  (error),
		.data   (data)
	);

	initial begin
		enable = 0;
		clock = 0;
		rx = 1;

		#30;
		enable = 1;

		#30;
		rx = 0;
		#20;
		rx = 1;
		#20;
		rx = 0;
		#20;
		rx = 1;
		#20;
		rx = 0;
		#20;
		rx = 1;
		#20;
		rx = 0;
		#20;
		rx = 1;
		#20;
		rx = 0;
		#20;
		rx = 1;
	end

	always #10 clock = ~clock;

	initial
		#1000 $finish;

	initial
		$monitor("clock=%b enable=%b rx=%b done=%b error=%b data=%b",
			clock, enable, rx, done, error, data);

	initial
		$dumpvars;

endmodule // testbench
