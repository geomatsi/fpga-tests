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

	reg [3:0] mux_in; // xxx
	reg [DATA_WIDTH - 1 : 0] mux_out;

	wire [DATA_WIDTH - 1 : 0] reg0;
	wire [DATA_WIDTH - 1 : 0] reg1;
	wire [DATA_WIDTH - 1 : 0] reg2;
	wire [DATA_WIDTH - 1 : 0] reg3;

	always @ (w_en, addr) begin
		if (w_en)
			case (addr)
				2'b00 : mux_in = 4'b0001;
				2'b01 : mux_in = 4'b0010;
				2'b10 : mux_in = 4'b0100;
				2'b11 : mux_in = 4'b1000;
				default : mux_in = 4'b0000;
			endcase
		else
			mux_in = 4'b0000;
	end

	always @ (addr, reg0, reg1, reg2, reg3)
		case (addr)
			2'b00 : mux_out = reg0;
			2'b01 : mux_out = reg1;
			2'b10 : mux_out = reg2;
			2'b11 : mux_out = reg3;
			default : mux_in = 4'b0000;
		endcase

	assign data_out = mux_out;

	register #(.SIZE(DATA_WIDTH)) register0(.clk(clk), .w_en(mux_in[0]), .d(data_in), .q(reg0));
	register #(.SIZE(DATA_WIDTH)) register1(.clk(clk), .w_en(mux_in[1]), .d(data_in), .q(reg1));
	register #(.SIZE(DATA_WIDTH)) register2(.clk(clk), .w_en(mux_in[2]), .d(data_in), .q(reg2));
	register #(.SIZE(DATA_WIDTH)) register3(.clk(clk), .w_en(mux_in[3]), .d(data_in), .q(reg3));
endmodule
