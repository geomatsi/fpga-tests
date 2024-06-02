// 1-bit magnitude comparator
// - straightforward implementation based on simple logic, see:
//   - https://en.wikipedia.org/wiki/Digital_comparator
//   - https://www.geeksforgeeks.org/magnitude-comparator-in-digital-logic/
module cmp_1bit
(
	input  a,
	input  b,
	output gt,  // a >  b
	output eq,  // a == b
	output lt   // a <  b
);

	wire t1, t2;

	assign t1 = a & (~b);
	assign t2 = (~a) & b;

	assign gt = t1;
	assign eq = ~(t1 | t2);
	assign lt = t2;

endmodule

// 2-bit magnitude comparator
// - straightforward implementation based on simple logic, see:
//   - https://www.geeksforgeeks.org/magnitude-comparator-in-digital-logic/
module cmp_2bit
(
	input  [1:0] a,
	input  [1:0] b,
	output gt,       // a >  b 
	output eq,       // a == b
	output lt        // a <  b
);

	wire [2:0] gtw;
	wire [2:0] ltw;
	wire [1:0] eqw;

	and(gtw[0], a[1], (~b[1]));
	and(gtw[1], a[0], (~b[1]), (~b[0]));
	and(gtw[2], a[1], a[0], (~b[0]));

	or(gt, gtw[2], gtw[1], gtw[0]);

	and(ltw[0], b[1], (~a[1]));
	and(ltw[1], b[0], (~a[1]), (~a[0]));
	and(ltw[2], b[1], b[0], (~a[0]));

	or(lt, ltw[2], ltw[1], ltw[0]);

	xor(eqw[0], a[0], b[0]);
	xor(eqw[1], a[1], b[1]);

	and(eq, ~eqw[1], ~eqw[0]);
endmodule

// 4-bit magnitude comparator
// - cascading implementation based on 2-bit magnitude comparator
//   - https://www.geeksforgeeks.org/magnitude-comparator-in-digital-logic/
module cmp_4bit_cascaded
(
	input  [3:0] a,
	input  [3:0] b,
	output gt,       // a >  b 
	output eq,       // a == b
	output lt        // a <  b
);

	wire [1:0] gtw;
	wire [1:0] ltw;
	wire [1:0] eqw;

	// compare lower 2-bits
	cmp_2bit c0(
		.a  (a[1:0]),
		.b  (b[1:0]),
		.gt (gtw[0]),
		.eq (eqw[0]),
		.lt (ltw[0])
	);

	// compare higher 2-bits
	cmp_2bit c1(
		.a  (a[3:2]),
		.b  (b[3:2]),
		.gt (gtw[1]),
		.eq (eqw[1]),
		.lt (ltw[1])
	);

	assign gt = gtw[1] | (eqw[1] & gtw[0]);
	assign lt = ltw[1] | (eqw[1] & ltw[0]);
	assign eq = eqw[1] & eqw[0];

endmodule

// 8-bit magnitude comparator
// - cascading implementation based on 4-bit magnitude comparator
//   - https://www.geeksforgeeks.org/magnitude-comparator-in-digital-logic/
module cmp_8bit_cascaded
(
	input  [7:0] a,
	input  [7:0] b,
	output gt,       // a >  b 
	output eq,       // a == b
	output lt        // a <  b
);

	wire [1:0] gtw;
	wire [1:0] ltw;
	wire [1:0] eqw;

	// compare lower 2-bits
	cmp_4bit_cascaded c0(
		.a  (a[3:0]),
		.b  (b[3:0]),
		.gt (gtw[0]),
		.eq (eqw[0]),
		.lt (ltw[0])
	);

	// compare higher 2-bits
	cmp_4bit_cascaded c1(
		.a  (a[7:4]),
		.b  (b[7:4]),
		.gt (gtw[1]),
		.eq (eqw[1]),
		.lt (ltw[1])
	);

	assign gt = gtw[1] | (eqw[1] & gtw[0]);
	assign lt = ltw[1] | (eqw[1] & ltw[0]);
	assign eq = eqw[1] & eqw[0];

endmodule
