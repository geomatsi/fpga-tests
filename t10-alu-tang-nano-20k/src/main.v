module alu_example(
    input  [1:0] key,
    output [5:0] led
);

    wire [5:0] data_out;
    wire [1:0] data_in;

    assign data_in[1:0] = key[1:0];
    assign led[5:0] = ~data_out;

    parameter WIDTH = 4;
    parameter SHIFT = 2;

    alu_structural #(.WIDTH(WIDTH), .SHIFT(SHIFT)) alu(
        .x         (4'b1100),
        .y         (4'b0110),
        .shamt     (2'b10),
        .operation (data_in),
        .carry_in  (1'b0),
        .result    (data_out[3:0]),
        .overflow  (data_out[4]),
        .zero      (data_out[5])
    );

endmodule
