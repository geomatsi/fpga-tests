// Image ROM

module tile_rom (
    input  wire        clk,
    input  wire [14:0] addr,       // 180 x 120 resolution gives [0 .. 21599] 3-byte words
    output reg  [23:0] data
);
    reg [23:0] mem [0:21599];      // 180 x 120
    initial $readmemh("../data/rom.hex", mem);
    always @(posedge clk) data <= mem[addr];
endmodule
