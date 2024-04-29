`timescale 1 ns / 100 ps

module testbench;

	reg  clk, w_en;
	reg [7:0] data_in;
	reg [3:0] addr;
	wire [7:0] data_out;

	regfile #(.DATA_WIDTH(8), .ADDR_WIDTH(4))  regfile1(clk, w_en, data_in, addr, data_out);

	initial begin
		clk = 1;
		w_en = 1;
		addr = 4'b0000;
		data_in = 8'b11111111;

		#5

		repeat (15) begin
			#20
			addr = addr + 2'b01;
		end

		#40

		w_en = 0;
		addr = 4'b0000;
		data_in = 8'b00000000;

		repeat (15) begin
			#20
			addr = addr + 2'b01;
		end

		#40

		w_en = 1;
		addr = 4'b0000;
		data_in = 8'b10101010;

		repeat (15) begin
			#20
			addr = addr + 2'b01;
		end

		#40

		w_en = 0;
		addr = 4'b0000;
		data_in = 8'b00000000;

		repeat (15) begin
			#20
			addr = addr + 2'b01;
		end
	end

	always #10 clk = ~clk;

	initial
		#1500 $finish;

	initial
		$monitor("clk=%b addr=%h data_in=%h data_out=%h", clk, addr, data_in, data_out);

	initial
		$dumpvars;
endmodule
