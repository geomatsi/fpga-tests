module jk_trigger
(
	input clk,
	input j,
	input k,
	input rst_n,
	output reg q
);

always @ (posedge clk)
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
