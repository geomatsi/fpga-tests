module uart_115200_8n1_test
(
    input clk,
    input ena,
    input [7:0] data,

    output tx,
    output done
);
    wire [9:0] edata = {1'b1, data, 1'b0};
    reg [4:0] cnt = 0;
    reg stop = 1'b0;
    reg bit = 1'b1;

    always @ (posedge clk or negedge ena)
    begin
        if (!ena)
            begin
                cnt  <= 4'b0;
                bit  <= 1'b1;
                stop <= 1'b0;
            end
        else
            if (!stop)
                begin
                    bit <= edata[cnt];
                    cnt <= cnt + 1'b1;
                    stop <= (cnt >= 9);
                end
            else
                bit <= 1'b1;
    end

    assign tx = bit;
    assign done = (stop == 1'b1);

endmodule
