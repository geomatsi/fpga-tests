`timescale 1 ns / 100 ps

module testbench;
	reg [1:0] d0, d1, d2, d3;
	reg [1:0] select;
	wire [1:0] mux_ternary_out;
	wire [1:0] mux_block_out;
	wire [1:0] mux_case_out;

	mux_2bit_4_1_ternary mux_2bit_4_1_ternary(d0, d1, d2, d3, select, mux_ternary_out);
	mux_2bit_4_1_block mux_2bit_4_1_block(d0, d1, d2, d3, select, mux_block_out);
	mux_2bit_4_1_case mux_2bit_4_1_case(d0, d1, d2, d3, select, mux_case_out);
    
	initial $dumpvars;

	initial
	begin
		$monitor ("%0d d0 %b d1 %b d2 %b d3 %b select %b mux_ternary_out %b mux_block_out %b mux_case_out %b",
			$time, d0, d1, d2, d3, select, mux_ternary_out, mux_block_out, mux_case_out);

		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b00; select = 2'b00;
		#10; d0 = 2'b01; d1 = 2'b00; d2 = 2'b00; d3 = 2'b00; select = 2'b00;
		#10; d0 = 2'b10; d1 = 2'b00; d2 = 2'b00; d3 = 2'b00; select = 2'b00;
		#10; d0 = 2'b11; d1 = 2'b00; d2 = 2'b00; d3 = 2'b00; select = 2'b00;

		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b00; select = 2'b01;
		#10; d0 = 2'b00; d1 = 2'b01; d2 = 2'b00; d3 = 2'b00; select = 2'b01;
		#10; d0 = 2'b00; d1 = 2'b10; d2 = 2'b00; d3 = 2'b00; select = 2'b01;
		#10; d0 = 2'b00; d1 = 2'b11; d2 = 2'b00; d3 = 2'b00; select = 2'b01;

		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b00; select = 2'b10;
		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b01; d3 = 2'b00; select = 2'b10;
		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b10; d3 = 2'b00; select = 2'b10;
		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b11; d3 = 2'b00; select = 2'b10;

		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b00; select = 2'b11;
		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b01; select = 2'b11;
		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b10; select = 2'b11;
		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b11; select = 2'b11;

		#10; d0 = 2'b00; d1 = 2'b00; d2 = 2'b00; d3 = 2'b11; select = 2'b11;

		$finish;
	end
endmodule
