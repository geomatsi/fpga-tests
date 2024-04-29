`timescale 1 ns / 100 ps

module testbench;

	reg  clk, w_en;
	reg [3:0] data_in;
	reg [5:0] addr_in;
	wire [3:0] data_out;
	wire [5:0] addr_out;

	spram #(.DATA_WIDTH(4), .ADDR_WIDTH(6))  mem(
		.clk(clk),
		.w_en(w_en),
		.data_in(data_in),
		.addr_in(addr_in),
		.data_out(data_out),
		.addr_out(addr_out)
	);

	initial begin
		clk = 0;
		w_en = 1;
		addr_in = 6'b000000;
		data_in = 4'b0000;

		#20

		// write to mem
		for(addr_in = 0; addr_in < (2 ** 6 - 1); addr_in += 1)
		begin
			data_in = addr_in[3:0];
			#20;
		end

		#40
		w_en = 0;

		// read from mem
		for(addr_in = 0; addr_in < (2 ** 6 - 1); addr_in += 1)
			#20;
	end

	always #10 clk = ~clk;

	initial
		#2000 $finish;

	initial
		$monitor("clk=%b addr_in=%h data_in=%h addr_out=%h data_out=%h", clk, addr_in, data_in, addr_out, data_out);

	initial
		$dumpvars;
endmodule
