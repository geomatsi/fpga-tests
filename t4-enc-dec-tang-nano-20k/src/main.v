module dec_example(
    input  [1:0] key,
    output [5:0] led
);

wire [2:0] dec_in;
wire [7:0] dec_out;
wire enable = 1'b1;

assign dec_in[2:0] = {0, key[1:0]};
assign led[5:0] = ~dec_out[5:0];

dec_case dec_case
(
    .in     (dec_in),
    .enable (enable),
    .out    (dec_out)
);

endmodule
