// Stack based on SP pointer
module stack_ptr
#(
	parameter DATA_WIDTH = 8,
	parameter SPTR_WIDTH = 2
)
(
	input clk,
	input rst_n,
	input push,
	input pop,
	input [DATA_WIDTH - 1 : 0] data_in,

	output reg full,
	output reg empty,
	output reg error,
	output reg [DATA_WIDTH - 1 : 0] data_out
);

	reg [DATA_WIDTH - 1 : 0] stack[(2 ** SPTR_WIDTH) - 1 : 0];
	reg [SPTR_WIDTH : 0] sp; // one extra bit to avoid overflow on full stack

	always @ (posedge clk or negedge rst_n) begin
		if (!rst_n)
			begin
				sp <= {SPTR_WIDTH{1'b0}};
				error <= 0;
				empty <= 1;
				full <= 0;
			end
		else
			case ({push, pop})
				2'b10:
					begin
						if (sp < 2 ** SPTR_WIDTH )
							begin
								stack[sp] <= data_in;
								sp <= sp + 1;
								empty <= 0;
							end
						else
								full <= 1;

						error <= 0;
					end
				2'b01:
					begin
						if (sp > 0)
							begin
								data_out <= stack[sp - 1];
								sp <= sp - 1;
								full <= 0;
							end
						else
							begin
								data_out <= 0;
								empty <= 1;
							end

						error <= 0;
					end
				2'b11:
					begin
						data_out <= stack[sp];
						error <= 1;
					end
				default:
					begin
						data_out <= stack[sp];
						error <= 0;
					end
			endcase
	end

endmodule
