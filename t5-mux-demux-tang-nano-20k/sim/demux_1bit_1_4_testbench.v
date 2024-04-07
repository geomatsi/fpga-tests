`timescale 1 ns / 100 ps

module testbench;
	reg din;
	reg [1:0] select;
	wire [3:0] dout_shift;
	wire [3:0] dout_case;

	demux_1bit_1_4_shift demux_1bit_1_4_shift(din, select, dout_shift[0], dout_shift[1], dout_shift[2], dout_shift[3]);
	demux_1bit_1_4_case demux_1bit_1_4_case(din, select, dout_case[0], dout_case[1], dout_case[2], dout_case[3]);
    
	initial $dumpvars;

	initial
	begin
		$monitor ("%0d din %b select %b dout_shift %b dout_case %b", $time, din, select, dout_shift, dout_case);

		#10; din = 0; select = 2'b00;
		#10; din = 0; select = 2'b01;
		#10; din = 0; select = 2'b10;
		#10; din = 0; select = 2'b11;

		#10; din = 1; select = 2'b00;
		#10; din = 1; select = 2'b01;
		#10; din = 1; select = 2'b10;
		#10; din = 1; select = 2'b11;

		#10; din = 0; select = 2'b00;

		$finish;
	end
endmodule
