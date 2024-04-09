`timescale 1 ns / 100 ps

module testbench;
parameter WIDTH = 4;

	reg c_in;
	reg [WIDTH - 1 : 0] x, y;
	wire c_out;
	wire [WIDTH - 1 : 0] z;

	simple_adder #(.WIDTH(WIDTH)) adder_sim(
		.carry_in (c_in),
		.x (x),
		.y (y),
		.z (z),
		.carry_out (c_out)
	);

	initial begin
		x = 0;
		y = 0;
		c_in = 0;
		#8
		$stop;
	end
    
	initial forever begin
		#1;
		x = $urandom_range(0, 2 ** WIDTH - 1);
		y = $urandom_range(0, 2 ** WIDTH - 1);
		c_in = $urandom_range(0, 1);
	end

	initial  begin
		$monitor ("Time: %g, x: %b, y: %b, c_in: %b, z: %b, c_out: %b",
			$time, x, y, c_in, z, c_out);
	end

	initial begin
		$dumpvars;
	end
endmodule
