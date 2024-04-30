`timescale 1 ns / 100 ps

module testbench;

	reg  clk;
	reg [1:0] addr_in;
	wire [3:0] data_out;
	wire [1:0] addr_out;

	sprom #(.DATA_WIDTH(4), .ADDR_WIDTH(2))  mem(
		.clk(clk),
		.addr_in(addr_in),
		.data_out(data_out),
		.addr_out(addr_out)
	);

	initial begin
		clk = 0;
		addr_in = 2'b00;

		#20

		// read from mem
		for(addr_in = 0; addr_in < (2 ** 2); addr_in += 1)
			#20;
	end

	always #10 clk = ~clk;

	initial
		#100 $finish;

	initial
		$monitor("clk=%b addr_in=%h addr_out=%h data_out=%h", clk, addr_in, addr_out, data_out);

	initial
		$dumpvars;
endmodule
