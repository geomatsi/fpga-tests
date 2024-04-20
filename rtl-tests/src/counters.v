// Synchronous 3-digit up-counter
// See chapter/section on synchronous counters
// in the "Digital Electronics" book by R. Tokheim

module sync_3bit_8_counter
(
	input clk,
	input rst_n,
	output [2:0] out
);
	wire a, b, c;

	jk_trigger jk1(
		.clk   (~clk),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (a)
	);

	jk_trigger jk2(
		.clk   (~clk),
		.j     (a),
		.k     (a),
		.rst_n (rst_n),
		.q     (b)
	);

	jk_trigger jk3(
		.clk   (~clk),
		.j     (a & b),
		.k     (a & b),
		.rst_n (rst_n),
		.q     (c)
	);

	assign out[0] = a;
	assign out[1] = b;
	assign out[2] = c;

endmodule

// Asynchronous 4-digit down-counter
// See chapter/section on asynchronous counters
// in the "Digital Electronics" book by R. Tokheim

module async_4bit_16_counter
(
	input clk,
	input rst_n,
	output [3:0] out
);
	jk_trigger jk1(
		.clk   (clk),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[0])
	);

	jk_trigger jk2(
		.clk   (out[0]),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[1])
	);

	jk_trigger jk3(
		.clk   (out[1]),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[2])
	);

	jk_trigger jk4(
		.clk   (out[2]),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[3])
	);

endmodule
