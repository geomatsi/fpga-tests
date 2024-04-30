module rom_example(
    input clk,
    input  [1:0] key,
    output [5:0] led
);

    wire [7:0] leds;
    wire [1:0] keys;

    assign led[5:0] = ~leds[5:0];

    sprom #(.DATA_WIDTH(4), .ADDR_WIDTH(2)) rom(
        .clk(clk),
        .addr_in(key[1:0]),
        .addr_out (leds[1:0]),
        .data_out (leds[5:2])
    );

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
		$readmemh("../src/rom.txt", rom, 0, 2 ** ADDR_WIDTH - 1);
	end

	always @ (posedge clk) begin
		addr_reg <= addr_in;
	end

	assign data_out = rom[addr_reg];
	assign addr_out = addr_reg;

endmodule