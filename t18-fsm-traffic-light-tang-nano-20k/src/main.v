module traffic_light_v1_test
#(
    parameter HZ = 5
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

    traffic_light_v1 tlv1(
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

module counter
(
    input [7:0] value,
    input clk_in,
    input rst_n,

    output [7:0] current,
    output ready
);
    reg [7:0] cnt = 8'b0;
    reg out = 0;

    assign current = cnt;
    assign ready = out;

    always @(posedge clk_in or negedge rst_n)
    begin
        if (!rst_n)
            begin
                cnt <= value;
                out <= 1'b0;
            end
        else if (cnt == 0)
            out <= 1'b1;
        else
            cnt <= cnt - 1'b1;
    end

endmodule

module traffic_light_v1
#(
    parameter RED_DURATION = 5,
    parameter GREEN_DURATION = 5,
    parameter YELLOW1_DURATION = 2,
    parameter YELLOW2_DURATION = 2,
    parameter GREEN_BLINK_DURATION = 6
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

    reg [7:0] tmr_val = 8'b00000000;
    reg tmr_rst_n = 1'b0;

    wire [7:0] tmr_current;
    wire tmr_ready;

    counter tmr(
        .value   (tmr_val),
        .clk_in  (clk_in),
        .rst_n   (tmr_rst_n),
        .ready   (tmr_ready),
        .current (tmr_current)
    );

    always @(posedge clk_in or negedge rst_n)
    begin
        if (!rst_n)
            begin
                curr_state <= TL_RED;
                tmr_val <= RED_DURATION;
                tmr_rst_n <= 1'b0;                
            end
        else if (tmr_ready)
            begin
                case (next_state)
                    TL_RED:
                        begin
                            curr_state <= next_state;
                            tmr_val <= RED_DURATION;
                            tmr_rst_n <= 1'b0;
                        end
                    TL_YELLOW1:
                        begin
                            curr_state <= next_state;
                            tmr_val <= YELLOW1_DURATION;
                            tmr_rst_n <= 1'b0;
                        end
                    TL_GREEN:
                        begin
                            curr_state <= next_state;
                            tmr_val <= GREEN_DURATION;
                            tmr_rst_n <= 1'b0;
                        end
                    TL_GREEN_PERM:
                        begin
                            if (detect)
                                curr_state <= next_state;
                        end
                    TL_GREEN_BLINK:
                        begin
                            curr_state <= next_state;
                            tmr_val <= GREEN_BLINK_DURATION;
                            tmr_rst_n <= 1'b0;
                        end
                    TL_YELLOW2:
                        begin
                            curr_state <= next_state;
                            tmr_val <= YELLOW2_DURATION;
                            tmr_rst_n <= 1'b0;
                        end
                    default:
                        begin
                            curr_state <= TL_RED;
                            tmr_val <= RED_DURATION;
                            tmr_rst_n <= 1'b0;
                        end
                endcase
            end
        else
            tmr_rst_n <= 1'b1; // release tmr
    end

    always @*
    begin
        case (curr_state)
            TL_RED: next_state = TL_YELLOW1;
            TL_YELLOW1: next_state = TL_GREEN;
            TL_GREEN: next_state = TL_GREEN_PERM;
            TL_GREEN_PERM: next_state = TL_GREEN_BLINK;
            TL_GREEN_BLINK: next_state = TL_YELLOW2;
            TL_YELLOW2: next_state = TL_RED;
            default: next_state = TL_RED;
        endcase
    end

    assign green = (curr_state == TL_GREEN) | (curr_state == TL_GREEN_PERM) | ((curr_state == TL_GREEN_BLINK) & (tmr_current & 1'b1));
    assign yellow = (curr_state == TL_YELLOW1) | (curr_state == TL_YELLOW2);
    assign red = (curr_state == TL_RED);

endmodule