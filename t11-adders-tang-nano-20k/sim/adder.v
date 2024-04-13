`timescale 1 ns / 100 ps

module testbench;

parameter WIDTH = 4;

	reg [WIDTH - 1 : 0] x;
	reg [WIDTH - 1 : 0] y;
	reg carry_in;

	wire [WIDTH - 1 : 0] z;
	wire carry_out;

	cascaded_adder #(.WIDTH(WIDTH)) adder_sim(
		.x         (x),
		.y         (y),
		.carry_in  (carry_in),
		.z         (z),
		.carry_out (carry_out)
	);

	initial begin
		x = 0;
		y = 0;
		carry_in = 0;

		#10
		$stop;
	end
    
	initial forever begin
		#1;
		x = $urandom_range(0, 2 ** WIDTH - 1);
		y = $urandom_range(0, 2 ** WIDTH - 1);
		carry_in = $urandom_range(0, 1);
	end

	initial  begin
		$monitor ("Time: %g, x: %b, y: %b, carry_in: %b, z: %b, carry_out: %b", $time, x, y, carry_in, z, carry_out);
	end

	initial begin
		$dumpvars;
	end
endmodule
