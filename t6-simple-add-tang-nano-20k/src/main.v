module add_example(
    input  [1:0] key,
    output [5:0] led
);

    wire [1:0] data_out;
    wire [1:0] data_in;
    wire c_in = 1'b0;

    assign data_in[1:0] = key[1:0];
    assign led[5:2] = 4'b1111;
    assign led[1:0] = ~data_out;

    parameter WIDTH = 1;
    simple_adder #(.WIDTH(WIDTH)) adder_sim(
        .carry_in (c_in),
        .x (data_in[0]),
        .y (data_in[1]),
        .z (data_out[0]),
        .carry_out (data_out[1])
    );

endmodule