`timescale 1 ns / 100 ps

module testbench;
	reg a;
	reg b;
	reg select;
	wire mux_ternary_out;
	wire mux_assign_out;
	wire mux_case_out;
	wire mux_if_out;

	mux_1bit_2_1_ternary mux_1bit_2_1_ternary(a, b, select, mux_ternary_out);
	mux_1bit_2_1_assign mux_1bit_2_1_assign(a, b, select, mux_assign_out);
	mux_1bit_2_1_case mux_1bit_2_1_case(a, b, select, mux_case_out);
	mux_1bit_2_1_if mux_1bit_2_1_if(a, b, select, mux_if_out);
    
	initial $dumpvars;

	initial
	begin
		$monitor ("%0d a %b b %b select %b mux_ternary_out %b mux_assign_out %b mux_case_out %b mux_if_out %b",
			$time, a, b, select, mux_ternary_out, mux_assign_out, mux_case_out, mux_if_out);

		#10; a = 0; b = 0; select = 0;
		#10; a = 0; b = 1; select = 0;
		#10; a = 1; b = 0; select = 0;
		#10; a = 1; b = 1; select = 0;

		#10; a = 0; b = 0; select = 1;
		#10; a = 0; b = 1; select = 1;
		#10; a = 1; b = 0; select = 1;
		#10; a = 1; b = 1; select = 1;

		$finish;
	end
endmodule
