module pwm_example(
    input clk,
    input  [1:0] key,
    output [5:0] led
);

    wire clk_out10;
    wire clk_out100;
    wire clk_out200;
    wire clk_out500;
    wire clk_out800;
    wire clk_out1000;

    assign led[0]   = ~clk_out10;
    assign led[1]   = ~clk_out100;
    assign led[2]   = ~clk_out200;
    assign led[3]   = ~clk_out500;
    assign led[4]   = ~clk_out800;
    assign led[5]   = ~clk_out1000;

    pwm #(.DIVISOR(1000), .DUTY(10)) pwm10(
            .clk_in  (clk),
            .clk_out (clk_out10)
    );

    pwm #(.DIVISOR(1000), .DUTY(100)) pwm100(
            .clk_in  (clk),
            .clk_out (clk_out100)
    );

    pwm #(.DIVISOR(1000), .DUTY(200)) pwm200(
            .clk_in  (clk),
            .clk_out (clk_out200)
    );

    pwm #(.DIVISOR(1000), .DUTY(500)) pwm500(
            .clk_in  (clk),
            .clk_out (clk_out500)
    );

    pwm #(.DIVISOR(1000), .DUTY(800)) pwm800(
            .clk_in  (clk),
            .clk_out (clk_out800)
    );

    pwm #(.DIVISOR(1000), .DUTY(1000)) pwm1000(
            .clk_in  (clk),
            .clk_out (clk_out1000)
    );
endmodule