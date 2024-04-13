module bn_mux_n1_generate
#(
    parameter DATA_WIDTH = 8,
    parameter SEL_WIDTH = 2
)
(
    input  [((2 ** SEL_WIDTH) * DATA_WIDTH) - 1 : 0] data_in,
    input  [SEL_WIDTH - 1 : 0] select,
    output [DATA_WIDTH - 1 : 0] data_out
);
    wire [DATA_WIDTH - 1 : 0] tmp_array [0 : (2 ** SEL_WIDTH) - 1];
    genvar i;

    generate
        for(i = 0; i < 2 ** SEL_WIDTH; i = i + 1)
        begin: gen_array
            assign tmp_array[i] = data_in[((i + 1) * DATA_WIDTH) - 1 : (i * DATA_WIDTH)];
        end
    endgenerate

    assign data_out = tmp_array[select];
endmodule