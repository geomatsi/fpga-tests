`timescale 1ns / 1ps

module testbench;
	reg clk = 0, rst_n = 0;
	always #5 clk = ~clk;
	wire t18, f18, c18, t5, f5, c5, t2, f2, c2;
	clk_div_en #(.DIV(18)) u18(.clk(clk), .rst_n(rst_n), .tick(t18), .tick_fall(f18), .clk_out(c18));
	clk_div_en #(.DIV(5))  u5 (.clk(clk), .rst_n(rst_n), .tick(t5),  .tick_fall(f5),  .clk_out(c5));
	clk_div_en #(.DIV(2))  u2 (.clk(clk), .rst_n(rst_n), .tick(t2),  .tick_fall(f2),  .clk_out(c2));
	
	integer n=0, last18=-1, per18=0, hi18=0, ticks18=0, bad=0;
	integer last5=-1, per5=0, hi5=0;
	integer last2=-1, per2=0;
	always @(posedge clk) if (rst_n) begin
        	n = n + 1;

		if (c18) hi18 = hi18 + 1;
		if (c5)  hi5  = hi5 + 1;
        	if (t18) begin
        		if (last18 >= 0 && n - last18 != 18) bad = bad + 1;
        		if (!c18) bad = bad + 1;           // tick must coincide with clk_out high
        		last18 = n; ticks18 = ticks18 + 1;
        	end
        	if (f18 && c18) bad = bad + 1;         // tick_fall must coincide with clk_out low
		if (t5) begin
        		if (last5 >= 0 && n - last5 != 5) bad = bad + 1;
        		last5 = n;
        	end
        	if (t2) begin
        		if (last2 >= 0 && n - last2 != 2) bad = bad + 1;
        		last2 = n;
        	end
	end

	initial begin
		#23 rst_n = 1;
		#(10*18*100);
		$display("DIV=18: ticks=%0d, duty high=%0d of %0d clocks (expect ~50%%)", ticks18, hi18, n);
		$display("DIV=5 : high=%0d of %0d clocks (expect 2/5 = 40%%)", hi5, n);
		$display("errors = %0d", bad);
		$finish;
	end

	initial
		$dumpvars;
endmodule
