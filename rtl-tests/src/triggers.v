module jk_trigger
(
	input clk,
	input j,
	input k,
	input rst_n,
	output reg q
);

	always @ (posedge clk or negedge rst_n)
	begin
		if (!rst_n)
			q <= 0;
		else begin
			if (j && k)
				q <= ~q;
			else if (j && ~k)
				q <= 1;
			else if (~j && k)
				q <= 0;
		end
	end
endmodule

module d_trigger
(
    input clk,
    input d,
    input set_n,
    input rst_n,
    output reg q
);

	always @ (posedge clk or negedge set_n or negedge rst_n)
	begin
		if (!set_n || !rst_n)
			case ({set_n, rst_n})
				2'b00:   q <= 1'b1;
				2'b10:   q <= 1'b0;
				2'b01:   q <= 1'b1;
				default: q <= d;    // unreachable
			endcase
		else
			q <= d;
	end
endmodule
