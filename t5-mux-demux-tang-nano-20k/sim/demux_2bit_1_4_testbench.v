`timescale 1 ns / 100 ps

module testbench;
	reg [1:0] din;
	reg [1:0] select;
	wire [1:0] dout0;
	wire [1:0] dout1;
	wire [1:0] dout2;
	wire [1:0] dout3;

	demux_2bit_1_4_block demux_2bit_1_4_block(din, select, dout0, dout1, dout2, dout3);

	initial $dumpvars;

	initial
	begin
		$monitor ("%0d din %b select %b dout0 %b dout1 %b dout2 %b dout3 %b", $time, din, select, dout0, dout1, dout2, dout3);

		#10; din = 2'b00; select = 2'b00;
		#10; din = 2'b00; select = 2'b01;
		#10; din = 2'b00; select = 2'b10;
		#10; din = 2'b00; select = 2'b11;

		#10; din = 2'b01; select = 2'b00;
		#10; din = 2'b01; select = 2'b01;
		#10; din = 2'b01; select = 2'b10;
		#10; din = 2'b01; select = 2'b11;

		#10; din = 2'b10; select = 2'b00;
		#10; din = 2'b10; select = 2'b01;
		#10; din = 2'b10; select = 2'b10;
		#10; din = 2'b10; select = 2'b11;

		#10; din = 2'b11; select = 2'b00;
		#10; din = 2'b11; select = 2'b01;
		#10; din = 2'b11; select = 2'b10;
		#10; din = 2'b11; select = 2'b11;

		#10; din = 2'b00; select = 2'b00;

		$finish;
	end
endmodule
