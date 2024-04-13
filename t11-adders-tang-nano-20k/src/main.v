module adder_example(
    input  [1:0] key,
    output [5:0] led
);
    parameter WIDTH = 5;

    wire [5:0] data_out;
    wire [1:0] data_in;

    assign data_in[1:0] = key[1:0];
    assign led[5:0] = ~data_out;

    cascaded_adder #(.WIDTH(WIDTH)) adder(
        .x         ({key[0], 4'b1000}),
        .y         ({key[1], 4'b0010}),
        .carry_in  (1'b0),
        .z         (data_out[4:0]),
        .carry_out (data_out[5])
    );

endmodule
