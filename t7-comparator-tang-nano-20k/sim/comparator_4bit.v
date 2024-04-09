`timescale 1 ns / 100 ps

module testbench;
parameter WIDTH = 4;

	reg [WIDTH - 1 : 0] x, y;
	wire eq, neq, lt, lte, gt, gte;

	comparator #(.WIDTH(WIDTH)) comparator_sim(
		.x   (x),
		.y   (y),
		.eq  (eq),
		.gt  (gt),
		.lt  (lt),
		.lte (lte),
		.gte (gte),
		.neq (neq)
	);

	initial begin
		x = 0;
		y = 0;
		#8
		$stop;
	end
    
	initial forever begin
		#1;
		x = $urandom_range(0, 2 ** WIDTH - 1);
		y = $urandom_range(0, 2 ** WIDTH - 1);
	end

	initial  begin
		$monitor ("Time: %g, x: %b, y: %b, eq: %b, neq: %b, lt: %b, lte: %b, gt: %b, gte: %b",
			$time, x, y, eq, neq, lt, lte, gt, gte);
	end

	initial begin
		$dumpvars;
	end
endmodule
