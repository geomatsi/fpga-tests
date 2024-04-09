module comparator_example(
    input  [1:0] key,
    output [5:0] led
);

    wire [5:0] data_out;
    wire [1:0] data_in;

    assign data_in[1:0] = key[1:0];
    assign led[5:0] = ~data_out;

    parameter WIDTH = 1;
    comparator #(.WIDTH(WIDTH)) comparator(
        .x   (data_in[0]),
        .y   (data_in[1]),
        .eq  (data_out[0]),
        .neq (data_out[1]),
        .lt  (data_out[2]),
        .gt  (data_out[3]),
        .lte (data_out[4]),
        .gte (data_out[5])
    );

endmodule