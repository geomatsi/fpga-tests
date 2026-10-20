module audio_drive(
    input        clk_1p536m,    // bit clock; each sample frame takes 32 clk_1p536m cycles (16 per channel, L and R)
    input        rst_n,         // asynchronous reset, active low

    // User data interface
    input [15:0] idata,         
    output       req,           // data request; can drive an external FIFO's read request (to avoid reading an empty FIFO, AND it with !fifo_empty and use that as fifo_rd)

    // I2S audio interface
    output       HP_BCK,        // same as clk_1p536m
    output       HP_WS,         // left/right channel select; low = left channel
    output       HP_DIN         // serial data input of the DAC
);

reg [15:0] idata_r;
reg [4:0] b_cnt;
reg HP_DIN_r;
reg HP_WS_r;
reg req_r1;
reg req_r;

assign HP_BCK = clk_1p536m;
assign HP_WS  = HP_WS_r;
assign HP_DIN = HP_DIN_r;
assign req    = req_r;


always@(posedge clk_1p536m or negedge rst_n)
begin
if(!rst_n)
    b_cnt    <= 5'd0;
else
    b_cnt <= b_cnt+1'b1;
end


always@(posedge clk_1p536m or negedge rst_n)
begin
if(!rst_n)
    req_r <= 1'b0;
else
    req_r <= (b_cnt == 5'd0) || (b_cnt == 5'd16);
end

always@(posedge clk_1p536m or negedge rst_n)
begin
if(!rst_n)
    begin
    req_r1  <= 1'b0;
    idata_r <= 16'd0;
    end
else
    begin
    req_r1  <= req_r;
    idata_r <= req_r1 ? idata : idata_r<<1;
    end
end

always@(posedge clk_1p536m or negedge rst_n)
begin
if(!rst_n)
    HP_DIN_r <= 1'b0;
else
    HP_DIN_r <= idata_r[15];
end

always@(posedge clk_1p536m or negedge rst_n)
begin
if(!rst_n)
    HP_WS_r <= 1'b0;
else
    HP_WS_r <= (b_cnt == 5'd3) ? 1'b0 : ((b_cnt == 5'd19) ? 1'b1 : HP_WS_r);
end

endmodule