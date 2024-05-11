module traffic_light_v1_test
#(
    parameter HZ = 4
)
(
    input clk,
    input  [1:0] key,
    output [5:0] led
);

    wire rst_n, detect;
    wire [2:0] led_n;
    wire clk_out;

    assign led[2:0] = ~led_n[2:0];
    assign led[5:3] = 3'b111;
    assign detect = key[0];
    assign rst_n = ~key[1];

    clk_divider #(.DIVISOR(27000000 / HZ)) divider(
            .clk_in  (clk),
            .clk_out (clk_out)
    );

    traffic_light_v1 #(.RED_DURATION(10), .GREEN_DURATION(20), .GREEN_BLINK_DURATION(8)) dev(
        .clk_in (clk_out),
        .detect (detect),
        .rst_n  (rst_n),
        .red    (led_n[0]),
        .yellow (led_n[1]),
        .green  (led_n[2])
    );

endmodule

module clk_divider
#(
    parameter DIVISOR = 27000000
)
(
    input  clk_in,
    output wire clk_out
);

    reg [32 : 0] cnt = DIVISOR;
    reg out = 0;

    assign clk_out = out;

    always @(posedge clk_in)
    begin
        if (cnt == 0)
            begin
                cnt <= DIVISOR;
                out <= 1'b1;
            end
        else
            begin
                cnt <= cnt - 1'b1;
                out <= 1'b0;
            end
    end

endmodule

module traffic_light_v1
#(
    parameter RED_DURATION = 10,
    parameter YELLOW1_DURATION = 4,
    parameter GREEN_DURATION = 10,
    parameter GREEN_BLINK_DURATION = 6,
    parameter YELLOW2_DURATION = 4
)
(
    input clk_in,
    input detect,
    input rst_n,

    output wire yellow,
    output wire green,
    output wire red
);

    parameter [2:0]
        TL_RED         = 3'b000,
        TL_YELLOW1     = 3'b001,
        TL_GREEN       = 3'b010,
        TL_GREEN_PERM  = 3'b011,
        TL_GREEN_BLINK = 3'b100,
        TL_YELLOW2     = 3'b101;

    reg [2:0] curr_state, next_state;
    reg [7:0] timer;

    always @(posedge clk_in or negedge rst_n)
    begin
        if (!rst_n)
            begin
                curr_state <= TL_RED;
                timer <= RED_DURATION;
            end
        else if (timer == 0)
            begin
                case (next_state)
                    TL_RED:
                        begin
                            timer <= RED_DURATION;
                            curr_state <= next_state;
                        end
                    TL_YELLOW1:
                        begin
                            timer <= YELLOW1_DURATION;
                            curr_state <= next_state;
                        end
                    TL_GREEN:
                        begin
                            timer <= GREEN_DURATION;
                            curr_state <= next_state;
                        end
                    TL_GREEN_PERM:
                        begin
                            curr_state <= next_state;
                        end
                    TL_GREEN_BLINK:
                        begin
                            timer <= GREEN_BLINK_DURATION;
                            curr_state <= next_state;
                        end
                    TL_YELLOW2:
                        begin
                            timer <= YELLOW2_DURATION;
                            curr_state <= next_state;
                        end
                endcase
            end
        else
            timer <= timer - 8'b1;
    end

    always @*
    begin
        if (timer == 0)
            case (curr_state)
                TL_RED:
                    begin
                        next_state = TL_YELLOW1;
                    end
                TL_YELLOW1:
                    begin
                        next_state = TL_GREEN;
                    end
                TL_GREEN:
                    begin
                        next_state = TL_GREEN_PERM;
                    end
                TL_GREEN_PERM:
                    begin
                        if (detect == 1'b1)
                            next_state = TL_GREEN_BLINK;
                        else
                            next_state = TL_GREEN_PERM;
                    end
                TL_GREEN_BLINK:
                    begin
                        next_state = TL_YELLOW2;
                    end
                TL_YELLOW2:
                    begin
                        next_state = TL_RED;
                    end
            endcase
    end

    assign green = (curr_state == TL_GREEN) | (curr_state == TL_GREEN_PERM) | ((curr_state == TL_GREEN_BLINK) & (timer & 1'b1));
    assign yellow = (curr_state == TL_YELLOW1) | (curr_state == TL_YELLOW2);
    assign red = (curr_state == TL_RED);

endmodule