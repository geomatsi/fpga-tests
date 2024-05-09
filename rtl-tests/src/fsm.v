// "Digital Synthesis" book by A.Romanov, Yu.Panchul
//  Chapter 8 FSM
//  Excercise 5.8.1 opt. 5
//
//  |---------|---------|---------|---------|---------|
//  |  INPUT  |                 STATE                 |
//  |         |---------|---------|---------|---------|
//  |         |    S0   |    S1   |    S2   |   S3    |
//  |---------|---------|---------|---------|---------|
//  |   A0    |  S3/Y3  |  S2/Y2  |  S1/Y1  |  S1/Y2  |
//  |   A1    |  S2/Y2  |  S3/Y2  |  S0/Y1  |  S1/Y1  |
//  |   A2    |  S2/Y2  |  S2/Y3  |  S2/Y3  |  S2/Y2  |
//  |   A3    |  S3/Y3  |  S1/Y0  |  S1/Y0  |  S2/Y2  |
//  |---------|---------|---------|---------|---------|
//

module fsm_test1
(
	input clock,
	input enable,
	input reset_n,
	input [1:0] a,
	output reg [1:0] y
);

	parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
	reg [1:0] curr_state, next_state;

	// state transition

	always @(posedge clock or negedge reset_n)
	begin
		if (!reset_n)
			curr_state <= S0;
		else if (enable)
			curr_state <= next_state;
	end

	// next state logic
	// output logic based on current state

	always @*
	begin
		case (curr_state)
			S0:
				case (a)
					2'b00: next_state = S3;
					2'b01: next_state = S2;
					2'b10: next_state = S2;
					2'b11: next_state = S3;
				endcase
			S1:
				case (a)
					2'b00: next_state = S2;
					2'b01: next_state = S3;
					2'b10: next_state = S2;
					2'b11: next_state = S1;
				endcase
			S2:
				case (a)
					2'b00: next_state = S1;
					2'b01: next_state = S0;
					2'b10: next_state = S2;
					2'b11: next_state = S1;
				endcase
			S3:
				case (a)
					2'b00: next_state = S1;
					2'b01: next_state = S1;
					2'b10: next_state = S2;
					2'b11: next_state = S2;
				endcase
			default:
				next_state = S0;
		endcase
	end


	always @(posedge clock or negedge reset_n)
	begin
		case (curr_state)
			S0:
				case (a)
					2'b00: y <= 2'b11;
					2'b01: y <= 2'b10;
					2'b10: y <= 2'b10;
					2'b11: y <= 2'b11;
				endcase
			S1:
				case (a)
					2'b00: y <= 2'b10;
					2'b01: y <= 2'b10;
					2'b10: y <= 2'b11;
					2'b11: y <= 2'b00;
				endcase
			S2:
				case (a)
					2'b00: y <= 2'b01;
					2'b01: y <= 2'b01;
					2'b10: y <= 2'b11;
					2'b11: y <= 2'b00;
				endcase
			S3:
				case (a)
					2'b00: y <= 2'b10;
					2'b01: y <= 2'b01;
					2'b10: y <= 2'b10;
					2'b11: y <= 2'b10;
				endcase
		endcase
	end

endmodule

// FSM example
//   - Gray code 2-bit counter
//   - simplified exercises 3.27 and 3.28 from 2xHarris
//

module fsm_test2_gray
(
	input clock,
	input reset_n,
	input direction,
	output [1:0] gc
);

	reg [1:0] curr_state, next_state;

	// state transition

	always @(posedge clock or negedge reset_n)
	begin
		if (!reset_n)
			curr_state <= 2'b00;
		else
			curr_state <= next_state;
	end

	// next state logic

	always @*
	begin
		next_state[0] = (~curr_state[1] ^ direction);
		next_state[1] = (curr_state[0] ^ direction);
	end

	assign gc[0] = (curr_state[0] == 1'b1);
	assign gc[1] = (curr_state[1] == 1'b1);

endmodule

// FSM example
//   - Gray code 3-bit counter
//   - exercise 3.27 from 2xHarris
//

module fsm_test3_gray
(
	input clock,
	input reset_n,
	output [2:0] gc
);
	wire [7:0] prnd;

	d_trigger d0(
		.clk   (clock),
		.d     (prnd[7]),
		.set_n (reset_n),
		.rst_n (1'b1),
		.q     (prnd[0])
	);

	d_trigger d1(
		.clk   (clock),
		.d     (prnd[0]),
		.set_n (1'b1),
		.rst_n (reset_n),
		.q     (prnd[1])
	);

	d_trigger d2(
		.clk   (clock),
		.d     (prnd[1]),
		.set_n (1'b1),
		.rst_n (reset_n),
		.q     (prnd[2])
	);

	d_trigger d3(
		.clk   (clock),
		.d     (prnd[2]),
		.set_n (1'b1),
		.rst_n (reset_n),
		.q     (prnd[3])
	);

	d_trigger d4(
		.clk   (clock),
		.d     (prnd[3]),
		.set_n (1'b1),
		.rst_n (reset_n),
		.q     (prnd[4])
	);

	d_trigger d5(
		.clk   (clock),
		.d     (prnd[4]),
		.set_n (1'b1),
		.rst_n (reset_n),
		.q     (prnd[5])
	);


	d_trigger d6(
		.clk   (clock),
		.d     (prnd[5]),
		.set_n (1'b1),
		.rst_n (reset_n),
		.q     (prnd[6])
	);


	d_trigger d7(
		.clk   (clock),
		.d     (prnd[6]),
		.set_n (1'b1),
		.rst_n (reset_n),
		.q     (prnd[7])
	);

	or(gc[2], prnd[4], prnd[5], prnd[6], prnd[7]);
	or(gc[1], prnd[2], prnd[3], prnd[4], prnd[5]);
	or(gc[0], prnd[1], prnd[2], prnd[5], prnd[6]);

endmodule
