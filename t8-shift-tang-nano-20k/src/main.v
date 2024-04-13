module shift_example(
    input  [1:0] key,
    output [5:0] led
);
    wire [5:0] data_out;
    wire [5:0] data_in;

    assign data_in[5:0] = {1'b0, key};
    assign led[5:0] = ~data_out;

    parameter WIDTH = 6;
    parameter SHIFT = 2;

    left_shifter #(.WIDTH(WIDTH), .SHIFT(SHIFT)) ls(
        .x     (data_in),
        .shamt (2'b10),
        .z     (data_out)
    );
endmodule
