`timescale 1 ns / 100 ps

module testbench;
	reg enable;
	reg [7:0] bits_in;
	wire [2:0] enc_assign_out;
	wire [2:0] enc_case_out;
	wire [2:0] enc_if_out;

	enc_assign enc_assign(bits_in, enable, enc_assign_out);
	enc_case enc_case(bits_in, enable, enc_case_out);
	enc_if enc_if(bits_in, enable, enc_if_out);
    
	initial $dumpvars;

	initial
	begin
		bits_in = 0;
        
		$monitor ("%0d bits_in %b enable %b enc_assign_out %b enc_case_out %b enc_if_out %b",
			$time, bits_in, enable, enc_assign_out, enc_case_out, enc_if_out);

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
		#10; bits_in=8'b10000001; enable = 1;
		#10; bits_in=8'b00000011; enable = 1;
		#10; bits_in=8'b00100011; enable = 1;
		#10; bits_in=8'b00000111; enable = 1;

		$finish;
	end
endmodule
