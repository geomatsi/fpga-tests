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

// 8-bit Fibonacci LFSR
// Pseudo-random sequence
// Note: set is used for reset to have 0xFF on reset

module lfsr_fibonacci
(
	input clk,
	input rst_n,
	output [7:0] prnd
);

	wire a, b, c;

	xor(a, prnd[5], prnd[7]);
	xor(b, a, prnd[4]);
	xor(c, b, prnd[3]);

	d_trigger d0(
		.clk   (clk),
		.d     (c),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[0])
	);

	d_trigger d1(
		.clk   (clk),
		.d     (prnd[0]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[1])
	);

	d_trigger d2(
		.clk   (clk),
		.d     (prnd[1]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[2])
	);

	d_trigger d3(
		.clk   (clk),
		.d     (prnd[2]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[3])
	);

	d_trigger d4(
		.clk   (clk),
		.d     (prnd[3]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[4])
	);

	d_trigger d5(
		.clk   (clk),
		.d     (prnd[4]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[5])
	);


	d_trigger d6(
		.clk   (clk),
		.d     (prnd[5]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[6])
	);


	d_trigger d7(
		.clk   (clk),
		.d     (prnd[6]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[7])
	);

endmodule

// 4-bit Simple LFSR
//   - https://vlsiverify.com/verilog/verilog-codes/lfsr/
// Note: set is used for reset to have 0xFF on reset

module lfsr_simple
(
	input clk,
	input rst_n,
	output [3:0] prnd
);

	wire a;

	xor(a, prnd[2], prnd[3]);

	d_trigger d0(
		.clk   (clk),
		.d     (a),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[0])
	);

	d_trigger d1(
		.clk   (clk),
		.d     (prnd[0]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[1])
	);

	d_trigger d2(
		.clk   (clk),
		.d     (prnd[1]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[2])
	);

	d_trigger d3(
		.clk   (clk),
		.d     (prnd[2]),
		.set_n (rst_n),
		.rst_n (1'b1),
		.q     (prnd[3])
	);

endmodule

// 4-bit Simple LFSR
//   - https://vlsiverify.com/verilog/verilog-codes/lfsr/
// Same as previous, but implemented in pure rtl w/o functional blocks

module lfsr_simple_rtl
(
	input clk,
	input rst_n,
	output reg [3:0] prnd
);

	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n)
			prnd <= 4'hF;
		else
			prnd = {prnd[2:0], prnd[2] ^ prnd[3]};
	end
endmodule
