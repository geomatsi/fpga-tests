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

// Asynchronous 4-digit counter
// See chapter/section on asynchronous counters
// in the "Digital Electronics" book by R. Tokheim

module async_4bit_16_counter
(
	input clk,
	input dir,
	input rst_n,
	output [3:0] out
);

	function clk_dir (input dir, clk);
		begin
			clk_dir = (dir == 1'b1) ? ~clk : clk;
		end
	endfunction

	jk_trigger jk1(
		.clk   (clk_dir(dir, clk)),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[0])
	);

	jk_trigger jk2(
		.clk   (clk_dir(dir, out[0])),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[1])
	);

	jk_trigger jk3(
		.clk   (clk_dir(dir, out[1])),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[2])
	);

	jk_trigger jk4(
		.clk   (clk_dir(dir, out[2])),
		.j     (1'b1),
		.k     (1'b1),
		.rst_n (rst_n),
		.q     (out[3])
	);

endmodule
