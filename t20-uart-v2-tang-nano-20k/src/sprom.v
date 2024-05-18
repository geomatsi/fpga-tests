// Single-port ROM
module sprom
#(
        parameter DATA_WIDTH = 8,
        parameter ADDR_WIDTH = 4
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
