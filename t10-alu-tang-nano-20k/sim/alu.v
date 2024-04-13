`timescale 1 ns / 100 ps

module testbench;

parameter WIDTH = 4;
parameter SHIFT = 2;

	reg  [WIDTH - 1 : 0] x;
	reg  [WIDTH - 1 : 0] y;
	reg  [SHIFT - 1 : 0] s;
	reg  [1:0] o;
	reg c;

	wire [WIDTH - 1 : 0] res;
	wire overflow;
	wire zero;

	alu_structural #(.WIDTH(WIDTH), .SHIFT(SHIFT)) alu_sim(
		.x         (x),
		.y         (y),
		.shamt     (s),
		.operation (o),
		.carry_in  (c),
		.result	   (res),
		.overflow  (overflow),
		.zero      (zero)
	);

	initial begin
		o = 0;
		c = 0;
		x = 0;
		y = 0;
		s = 0;

		#10
		$stop;
	end
    
	initial forever begin
		#1;
		x = $urandom_range(0, 2 ** WIDTH - 1);
		y = $urandom_range(0, 2 ** WIDTH - 1);
		s = $urandom_range(0, 2 ** SHIFT - 1);
		o = $urandom_range(0, 3);
		c = $urandom_range(0, 1);
	end

	initial  begin
		$monitor ("Time: %g, x: %b, y: %b, shamt: %b, carry: %b, operation: %b", $time, x, y, s, c, o);
	end

	initial begin
		$dumpvars;
	end
endmodule
