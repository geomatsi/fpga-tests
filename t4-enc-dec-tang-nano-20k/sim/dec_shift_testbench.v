`timescale 1 ns / 100 ps

module testbench;
	wire [7:0] bits_out;
	reg [2:0] bin_in;
	reg enable;

	dec_shift dec_shift(bin_in, enable, bits_out);
    
	initial $dumpvars;

	initial
	begin
		enable = 1;
		bin_in = 0;
        
		$monitor ("%0d bin_in %b enable %b bits_out %b", $time, bin_in, enable, bits_out);

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
