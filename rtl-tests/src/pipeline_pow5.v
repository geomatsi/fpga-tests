module pow_5_pipe_always
#(
	parameter w = 8
)
(
	input clk,
	input rst_n,
	input arg_valid,
	input [w - 1 : 0] arg,
	output [4 : 0] res_valid,
	output [5 * w - 1 : 0] res
);

	reg [w - 1 : 0] arg1, arg2, arg3, arg4;
	reg [w - 1 : 0] pow2, pow3, pow4, pow5;

	reg arg_valid_1;
	reg arg_valid_2;
	reg arg_valid_3;
	reg arg_valid_4;
	reg arg_valid_5;

	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
		begin
			arg_valid_1 <= 1'b0;
			arg_valid_2 <= 1'b0;
			arg_valid_3 <= 1'b0;
			arg_valid_4 <= 1'b0;
			arg_valid_5 <= 1'b0;
		end
		else
		begin
			arg_valid_1 <= arg_valid;
			arg_valid_2 <= arg_valid_1;
			arg_valid_3 <= arg_valid_2;
			arg_valid_4 <= arg_valid_3;
			arg_valid_5 <= arg_valid_4;
		end
	end

	always @ (posedge clk)
	begin
		arg1 <= arg;
		arg2 <= arg1;
		arg3 <= arg2;
		arg4 <= arg3;

		pow2 <= arg1 * arg1;
		pow3 <= pow2 * arg2;
		pow4 <= pow3 * arg3;
		pow5 <= pow4 * arg4;
	end

	assign res_valid = { arg_valid_1, arg_valid_2, arg_valid_3, arg_valid_4, arg_valid_5 };
	assign res = { arg1, pow2, pow3, pow4, pow5 };

endmodule
