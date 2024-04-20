// SIPO: serial-in-parallel-out 4bit shift register
// See chapter/section 8.1 on shift registers
// in the "Digital Electronics" book by R. Tokheim

module shift_sipo_4bit
(
	input clk,
	input rst_n,
	input s_in,
	output [3:0] p_out
);

	d_trigger d1(
		.clk   (clk),
		.d     (s_in),
		.set_n (1'b1),
		.rst_n (rst_n),
		.q     (p_out[0])
	);

	d_trigger d2(
		.clk   (clk),
		.d     (p_out[0]),
		.set_n (1'b1),
		.rst_n (rst_n),
		.q     (p_out[1])
	);

	d_trigger d3(
		.clk   (clk),
		.d     (p_out[1]),
		.set_n (1'b1),
		.rst_n (rst_n),
		.q     (p_out[2])
	);

	d_trigger d4(
		.clk   (clk),
		.d     (p_out[2]),
		.set_n (1'b1),
		.rst_n (rst_n),
		.q     (p_out[3])
	);

endmodule

// PIPO: parallel-in-parallel-out 4bit shift ring counter
// See chapter/section 8.2 on shift registers
// in the "Digital Electronics" book by R. Tokheim

module ring_sipo_4bit
(
	input clk,
	input rst_n,
	input [3:0] p_in,
	output [3:0] p_out
);

	d_trigger d1(
		.clk   (clk),
		.d     (p_out[3]),
		.set_n (~p_in[0]),
		.rst_n (rst_n),
		.q     (p_out[0])
	);

	d_trigger d2(
		.clk   (clk),
		.d     (p_out[0]),
		.set_n (~p_in[1]),
		.rst_n (rst_n),
		.q     (p_out[1])
	);

	d_trigger d3(
		.clk   (clk),
		.d     (p_out[1]),
		.set_n (~p_in[2]),
		.rst_n (rst_n),
		.q     (p_out[2])
	);

	d_trigger d4(
		.clk   (clk),
		.d     (p_out[2]),
		.set_n (~p_in[3]),
		.rst_n (rst_n),
		.q     (p_out[3])
	);

endmodule
