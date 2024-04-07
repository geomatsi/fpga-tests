`timescale 1 ns / 100 ps

module testbench;
	reg enable;
	reg [2:0] bin_in;
	wire [7:0] dec_case_out;
	wire [7:0] dec_shift_out;

	dec_case dec_case(bin_in, enable, dec_case_out);
	dec_shift dec_shift(bin_in, enable, dec_shift_out);
    
	initial $dumpvars;

	initial
	begin
		enable = 1;
		bin_in = 0;
        
		$monitor ("%0d bin_in %b enable %b dec_case_out %b dec_shift_out %b",
			$time, bin_in, enable, dec_case_out, dec_shift_out);

		#10; bin_in=3'b000; enable = 1;
		#10; bin_in=3'b001; enable = 1;
		#10; bin_in=3'b010; enable = 1;
		#10; bin_in=3'b011; enable = 1;
		#10; bin_in=3'b100; enable = 1;
		#10; bin_in=3'b101; enable = 1;
		#10; bin_in=3'b110; enable = 1;
		#10; bin_in=3'b111; enable = 1;

		#10; bin_in=3'b000; enable = 0;
		#10; bin_in=3'b001; enable = 0;
		#10; bin_in=3'b010; enable = 0;
		#10; bin_in=3'b011; enable = 0;
		#10; bin_in=3'b100; enable = 0;
		#10; bin_in=3'b101; enable = 0;
		#10; bin_in=3'b110; enable = 0;
		#10; bin_in=3'b111; enable = 0;

		$finish;
	end
endmodule
