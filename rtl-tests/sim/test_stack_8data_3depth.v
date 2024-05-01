`timescale 1 ns / 100 ps

module testbench;

	reg  clk, rst_n, push, pop;
	reg [7:0] data_in;

	wire error, empty, full;
	wire [7:0] data_out;

	stack_ptr #(.DATA_WIDTH(8), .SPTR_WIDTH(3))  stack(
		.clk      (clk),
		.rst_n    (rst_n),
		.push     (push),
		.pop      (pop),
		.full     (full),
		.empty    (empty),
		.error    (error),
		.data_in  (data_in),
		.data_out (data_out)
	);

	initial begin
		clk = 0;
		pop = 0;
		push = 0;
		rst_n = 0;

		#40
		rst_n = 1;

		#20;
		push = 1;
		data_in = 8'b00001111;

		// write to stack
                repeat (8) begin
                        #20;
                        data_in = data_in - 8'b00000001;
                end

		#20;
		push = 0;

		#50;
		push = 1;
		pop = 1;

		#50;
		push = 0;
		pop = 0;

		#20;
		pop = 1;

		// read from stack
                repeat (8) begin
                        #20;
                end

		#20;
		pop = 0;

		#50;
		push = 1;
		pop = 1;

		#50;
		push = 0;
		pop = 0;
	end

	always #10 clk = ~clk;

	initial
		#1000 $finish;

	initial
		$monitor("clk=%b rst_n=%b push=%h pop=%h full=%b empty=%b error=%b data_in=%h data_out=%h",
				clk, rst_n, push, pop, full, empty, error, data_in, data_out);

	initial
		$dumpvars;
endmodule
