// priority encoder 4-2
// - straightforward implementation based on simple logic
// - see https://en.wikipedia.org/wiki/Priority_encoder
module prio_enc_4_2
(
	input  [3:0] di,
	output [1:0] do,
	output valid
);

	wire t1, t2;

	assign t1 = di[1] & (~di[2]);
	assign t2 = di[2] | di[3];

	assign valid = t2 | di[1] | di[0];
	assign do[0] = di[3] | t1;
	assign do[1] = t2;

endmodule

// prio_enc_16_4
// - recursive implementation based on priority encoders 4-2
// - see https://en.wikipedia.org/wiki/Priority_encoder
module prio_enc_16_4
(
	input  [15:0] di,
	output [3:0] do,
	output valid
);

	wire [1:0] pev_out;
	wire [1:0] mux_out;
	wire [3:0] pe_valid;

	wire [1:0] pe0_out;
	wire [1:0] pe1_out;
	wire [1:0] pe2_out;
	wire [1:0] pe3_out;

	prio_enc_4_2 pe0(
		.di    (di[3:0]),
		.do    (pe0_out),
		.valid (pe_valid[0])
	);

	prio_enc_4_2 pe1(
		.di    (di[7:4]),
		.do    (pe1_out),
		.valid (pe_valid[1])
	);

	prio_enc_4_2 pe2(
		.di    (di[11:8]),
		.do    (pe2_out),
		.valid (pe_valid[2])
	);

	prio_enc_4_2 pe3(
		.di    (di[15:12]),
		.do    (pe3_out),
		.valid (pe_valid[3])
	);

	prio_enc_4_2 pev(
		.di    (pe_valid[3:0]),
		.do    (pev_out),
		.valid (valid)
	);

	mux_2bit_4_1 mux(
		.d0  (pe0_out),
		.d1  (pe1_out),
		.d2  (pe2_out),
		.d3  (pe3_out),
		.sel (pev_out),
		.y   (mux_out)
	);

	assign do[1:0] = mux_out;
	assign do[3:2] = pev_out;

endmodule
