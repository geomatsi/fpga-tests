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
