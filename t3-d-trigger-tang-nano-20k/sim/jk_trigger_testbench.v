`timescale 1 ns / 100 ps

module testbench;

    reg  clk, j, k;
    wire q;

    jk_trigger jk_trigger(clk, j, k, q);
    
    initial $dumpvars;

    initial
    begin
        
        $monitor ("%0d clk %b j %b k %b q %b", $time, clk, j, k, q);

        # 10;   clk = 0; j = 0; k = 0;
        # 10;   clk = 1; j = 0; k = 0;
        # 10;   clk = 0; j = 0; k = 0;
        # 10;   clk = 1; j = 0; k = 0;
        # 10;   clk = 0; j = 1; k = 0;
        # 10;   clk = 1; j = 1; k = 0;
        # 10;   clk = 0; j = 1; k = 0;
        # 10;   clk = 1; j = 1; k = 0;
        # 10;   clk = 0; j = 0; k = 1;
        # 10;   clk = 1; j = 0; k = 1;
        # 10;   clk = 0; j = 0; k = 1;
        # 10;   clk = 1; j = 0; k = 1;
        # 10;   clk = 0; j = 1; k = 1;
        # 10;   clk = 1; j = 1; k = 1;
        # 10;   clk = 0; j = 1; k = 1;
        # 10;   clk = 1; j = 1; k = 1;
        # 10;   clk = 0; j = 1; k = 1;
        # 10;   clk = 1; j = 1; k = 1;
        # 20;

        $finish;
    end

endmodule
