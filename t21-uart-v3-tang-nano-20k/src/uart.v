module uart_115200_8n1_v2_rx
(
    input rx,
    input clock,
    input enable,

    output reg done,
    output reg error,
    output reg [7:0] data
);

    parameter [4:0]
        S00 = 00, /* READY */
        S01 = 01, /* RECV1 */
        S02 = 02, /* RECV2 */
        S03 = 03, /* RECV3 */
        S04 = 04, /* RECV4 */
        S05 = 05, /* RECV5 */
        S06 = 06, /* RECV6 */
        S07 = 07, /* RECV7 */
        S08 = 08, /* RECV8 */
        S09 = 09, /* STOP  */
        S10 = 10; /* ERROR */

    reg [3:0] curr_state, next_state;
    reg [7:0] buff;

    // state transition

    always @(posedge clock or negedge enable)
    begin
		if (!enable)
			curr_state <= S00;
		else
			curr_state <= next_state;
    end

    // next state logic

    always @*
    begin
        case (curr_state)
            S00:
                case (rx)
					1'b0: next_state = S01;
					1'b1: next_state = S00;
				endcase
			S01:
                next_state = S02;
			S02:
                next_state = S03;
			S03:
                next_state = S04;
			S04:
                next_state = S05;
			S05:
                next_state = S06;
			S06:
                next_state = S07;
			S07:
                next_state = S08;
			S08:
                next_state = S09;
			S09:
				case (rx)
					1'b0: next_state = S10;
					1'b1: next_state = S00;
				endcase
			S10:
				case (rx)
					1'b0: next_state = S10;
					1'b1: next_state = S00;
				endcase
			default:
				next_state = S00;
		endcase
	end

    // register output logic based on the current state

	always @(posedge clock or negedge enable)
	begin
		if (!enable)
            begin
                data <= 8'b0;
                done <= 0;
                error <= 0;
            end
		else
            case (curr_state)
                S00:
                    begin
                        buff <= 8'b0;
                        error <= 0;
                        done <= 0;
                    end
                S01:
                    buff <= buff | (rx << 0);
                S02:
                    buff <= buff | (rx << 1);
                S03:
                    buff <= buff | (rx << 2);
                S04:
                    buff <= buff | (rx << 3);
                S05:
                    buff <= buff | (rx << 4);
                S06:
                    buff <= buff | (rx << 5);
                S07:
                    buff <= buff | (rx << 6);
                S08:
                    buff <= buff | (rx << 7);
                S09:
                    if (rx) begin
                        data <= buff;
                        done <= 1;
                    end
                S10:
                    begin
                        data <= 8'b0;
                        error <= 1;
                    end
            endcase
	end

endmodule
