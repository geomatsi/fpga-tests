`timescale 1 ns / 100 ps

module testbench;

parameter WIDTH = 8;
parameter SHIFT = 3;

	reg  [WIDTH - 1 : 0] din;
	reg  [SHIFT - 1 : 0] sht;
	wire [WIDTH - 1 : 0] rrt;
	wire [WIDTH - 1 : 0] lrt;

	left_rotator #(.WIDTH(WIDTH), .SHIFT(SHIFT)) lrt_sim(
		.x       (din),
		.shamt   (sht),
		.z       (lrt)
	);

	right_rotator #(.WIDTH(WIDTH), .SHIFT(SHIFT)) rrt_sim(
		.x       (din),
		.shamt   (sht),
		.z       (rrt)
	);

	initial begin
		din = 0;
		sht = 0;
		#10
		$stop;
	end
    
	initial forever begin
		#1;
		din = $urandom_range(0, 2 ** WIDTH - 1);
		sht = $urandom_range(0, 2 ** SHIFT - 1);
	end

	initial  begin
		$monitor ("Time: %g, din: %b, sht: %b, rrt: %b, lrt: %b",
			$time, din, sht, rrt, lrt);
	end

	initial begin
		$dumpvars;
	end
endmodule
