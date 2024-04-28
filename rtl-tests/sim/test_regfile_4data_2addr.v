`timescale 1 ns / 100 ps

module testbench;

	reg  clk, w_en;
	reg [3:0] data_in;
	reg [1:0] addr;
	wire [3:0] data_out;

	regfile regfile1(clk, w_en, data_in, addr, data_out);

	initial begin
		clk = 1;
		w_en = 1;
		addr = 2'b00;
		data_in = 4'b1111;

		#5

		repeat (3) begin
			#20
			addr = addr + 2'b01;
		end

		#40

		w_en = 0;
		addr = 2'b00;
		data_in = 4'b0000;

		repeat (3) begin
			#20
			addr = addr + 2'b01;
		end

		#40

		w_en = 1;
		addr = 2'b00;
		data_in = 4'b1010;

		repeat (3) begin
			#20
			addr = addr + 2'b01;
		end

		#40

		w_en = 0;
		addr = 2'b00;
		data_in = 4'b0000;

		repeat (3) begin
			#20
			addr = addr + 2'b01;
		end
	end

	always #10 clk = ~clk;

	initial
		#500 $finish;

	initial
		$monitor("clk=%b addr=%h data_in=%h data_out=%h", clk, addr, data_in, data_out);

	initial
		$dumpvars;
endmodule
