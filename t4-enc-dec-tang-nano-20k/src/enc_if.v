module enc_if(
    input [7:0] in,
    input enable,
    output reg [2:0] out
);
    always @ (*)
        begin
            out = 0;
            if (enable) begin
                if (in == 16'h1) begin
                    out = 0;
                end
                if (in == 16'h2) begin
                    out = 1;
                end
                if (in == 16'h4) begin
                    out = 2;
                end
                if (in == 16'h8) begin
                    out = 3;
                end
                if (in == 16'h10) begin
                    out = 4;
                end
                if (in == 16'h20) begin
                    out = 5;
                end
                if (in == 16'h40) begin
                    out = 6;
                end
                if (in == 16'h80) begin
                    out = 7;
                end
            end
        end
endmodule
