// Single-port RAM
module spram
#(
	parameter DATA_WIDTH = 4,
	parameter ADDR_WIDTH = 2
)
(
	input clk,
	input w_en,
	input [DATA_WIDTH - 1 : 0] data_in,
	input [ADDR_WIDTH - 1 : 0] addr_in,
	output [DATA_WIDTH - 1 : 0] data_out,
	output [ADDR_WIDTH - 1 : 0] addr_out
);

	reg [DATA_WIDTH - 1 : 0] memory[(2 ** ADDR_WIDTH) - 1 : 0];
	reg [ADDR_WIDTH - 1 : 0] addr_reg;

	always @ (posedge clk) begin
		if (w_en)
			memory[addr_in] <= data_in;		
		addr_reg <= addr_in;
	end

	assign data_out = memory[addr_reg];
	assign addr_out = addr_reg;

endmodule

// Single-port ROM
module sprom
#(
	parameter DATA_WIDTH = 4,
	parameter ADDR_WIDTH = 2
)
(
	input clk,
	input [ADDR_WIDTH - 1 : 0] addr_in,
	output [DATA_WIDTH - 1 : 0] data_out,
	output [ADDR_WIDTH - 1 : 0] addr_out
);

	reg [DATA_WIDTH - 1 : 0] rom[(2 ** ADDR_WIDTH) - 1 : 0];
	reg [ADDR_WIDTH - 1 : 0] addr_reg;

	// Read ROM data from file
	initial begin
		// Note: file suitable only for default params
		$readmemh("../data/rom1.txt", rom, 0, 2 ** ADDR_WIDTH - 1);
	end

	always @ (posedge clk) begin
		addr_reg <= addr_in;
	end

	assign data_out = rom[addr_reg];
	assign addr_out = addr_reg;

endmodule

// Binary-to-BCD decoder for 8bit binary data
module bin2bcd
#(
	parameter BIN_WIDTH = 8,    // 8bit binary input
	parameter BCD_WIDTH = 12    // 12bit BCD output since max number is 255
)
(
	input clk,
	input [BIN_WIDTH - 1 : 0] bin_in,

	output [BCD_WIDTH - 1 : 0] bcd_out,
	output [BIN_WIDTH - 1 : 0] bin_out
);

	reg [BCD_WIDTH - 1 : 0] rom[(2 ** BIN_WIDTH) - 1 : 0];
	reg [BIN_WIDTH - 1 : 0] addr;

	// Read ROM data from file
	initial begin
		// Note: file suitable only for default params
		$readmemh("../data/rom2.txt", rom, 0, 2 ** BIN_WIDTH - 1);
	end

	always @ (posedge clk) begin
		addr <= bin_in;
	end

	assign bcd_out = rom[addr];
	assign bin_out = addr;

endmodule
