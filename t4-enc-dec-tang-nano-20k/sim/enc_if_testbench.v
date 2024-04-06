`timescale 1 ns / 100 ps

module testbench;
	reg [7:0] bits_in;
	wire [2:0] bin_out;
	reg enable;

	enc_if enc_if(bits_in, enable, bin_out);
    
	initial $dumpvars;

	initial
	begin
		bits_in = 0;
        
		$monitor ("%0d bits_in %b enable %b bin_out %b", $time, bits_in, enable, bin_out);

		#10; bits_in=8'b00000000; enable = 1;
		#10; bits_in=8'b00000001; enable = 1;
		#10; bits_in=8'b00000010; enable = 1;
		#10; bits_in=8'b00000100; enable = 1;
		#10; bits_in=8'b00001000; enable = 1;
		#10; bits_in=8'b00010000; enable = 1;
		#10; bits_in=8'b00100000; enable = 1;
		#10; bits_in=8'b01000000; enable = 1;
		#10; bits_in=8'b10000000; enable = 1;
		#10; bits_in=8'b00000000; enable = 0;
		#10; bits_in=8'b00000001; enable = 0;
		#10; bits_in=8'b00000010; enable = 0;
		#10; bits_in=8'b00000100; enable = 0;
		#10; bits_in=8'b00001000; enable = 0;
		#10; bits_in=8'b00010000; enable = 0;
		#10; bits_in=8'b00100000; enable = 0;
		#10; bits_in=8'b01000000; enable = 0;
		#10; bits_in=8'b10000000; enable = 0;

		$finish;
	end
endmodule
