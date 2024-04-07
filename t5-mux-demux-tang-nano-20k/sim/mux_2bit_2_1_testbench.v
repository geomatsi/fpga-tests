`timescale 1 ns / 100 ps

module testbench;
	reg [1:0] a;
	reg [1:0] b;
	reg select;
	wire [1:0] mux_ternary_out;
	wire [1:0] mux_case_out;
	wire [1:0] mux_if_out;

	mux_2bit_2_1_ternary mux_2bit_2_1_ternary(a, b, select, mux_ternary_out);
	mux_2bit_2_1_case mux_2bit_2_1_case(a, b, select, mux_case_out);
	mux_2bit_2_1_if mux_2bit_2_1_if(a, b, select, mux_if_out);
    
	initial $dumpvars;

	initial
	begin
		$monitor ("%0d a %b b %b select %b mux_ternary_out %b mux_case_out %b mux_if_out %b",
			$time, a, b, select, mux_ternary_out, mux_case_out, mux_if_out);

		#10; a = 2'b00; b = 2'b00; select = 0;
		#10; a = 2'b01; b = 2'b00; select = 0;
		#10; a = 2'b10; b = 2'b00; select = 0;
		#10; a = 2'b11; b = 2'b00; select = 0;

		#10; a = 2'b00; b = 2'b00; select = 1;
		#10; a = 2'b00; b = 2'b01; select = 1;
		#10; a = 2'b00; b = 2'b10; select = 1;
		#10; a = 2'b00; b = 2'b11; select = 1;

		$finish;
	end
endmodule
