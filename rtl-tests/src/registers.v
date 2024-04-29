module register
#(
	parameter SIZE = 4
)
(
	input clk,
	input w_en,
	input [SIZE - 1 : 0] d,
	output reg [SIZE - 1 : 0] q
);
	always @ (posedge clk)
		if (w_en)
			q <= d;
endmodule

module regfile
#(
	parameter DATA_WIDTH = 4,
	parameter ADDR_WIDTH = 2
)
(
	input clk,
	input w_en,
	input [DATA_WIDTH - 1 : 0] data_in,
	input [ADDR_WIDTH - 1 : 0] addr,
	output [DATA_WIDTH - 1 : 0] data_out
);

	reg [(2 ** ADDR_WIDTH) - 1 : 0] mux_in;
	reg [DATA_WIDTH - 1 : 0] mux_out;
	wire [DATA_WIDTH - 1 : 0] reg_array [(2 ** ADDR_WIDTH) - 1 : 0];
	genvar i;

	always @ (w_en, addr) begin
		if (w_en)
			mux_in = 1'b1 << addr;
		else
			mux_in = 4'b0000;
	end

	always @ (*) begin // don't know how to keep addr and _full_ reg_array in sensitivity list
		mux_out = reg_array[addr];
	end

	assign data_out = mux_out;

	generate
		for(i = 0; i < 2 ** ADDR_WIDTH; i = i + 1)
		begin: gen_array
			register #(.SIZE(DATA_WIDTH)) registerX(.clk(clk), .w_en(mux_in[i]), .d(data_in), .q(reg_array[i]));
		end
	endgenerate

endmodule
