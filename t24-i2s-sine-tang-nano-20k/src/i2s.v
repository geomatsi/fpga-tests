module audio_drive(
    input        clk,           // system clock
    input        rst_n,         // asynchronous reset, active low
    input        bck,           // bit clock (clk_div_en clk_out), forwarded to HP_BCK
    input        bck_fall,      // 1-cycle enable after each BCK falling edge; all state advances here
                                // each sample frame takes 32 BCK periods (16 per channel, L and R)

    // User data interface
    input [15:0] idata,
    output       req,           // 1-cycle data request, twice per frame (before the L and R loads); idata is read on the next bck_fall

    // I2S audio interface
    output       HP_BCK,        // same as bck
    output       HP_WS,         // left/right channel select; low = left channel
    output       HP_DIN         // serial data input of the DAC
);

// HP_WS and HP_DIN change one clk after BCK falls, so they are stable
// for half a BCK period before the DAC samples them on the BCK rising edge.

// bck_falls from frame start (b_cnt 0) to the MSB on HP_DIN: req_r -> req_r1 -> idata_r -> HP_DIN_r
localparam LAT = 3;

reg [15:0] idata_r;
reg [4:0] b_cnt;
reg HP_DIN_r;
reg HP_WS_r;
reg req_r1;
reg req_r;

assign HP_BCK = bck;
assign HP_WS  = HP_WS_r;
assign HP_DIN = HP_DIN_r;
assign req    = req_r & bck_fall;


always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
    b_cnt    <= 5'd0;
else if(bck_fall)
    b_cnt <= b_cnt+1'b1;
end


always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
    req_r <= 1'b0;
else if(bck_fall)
    req_r <= (b_cnt == 5'd0) || (b_cnt == 5'd16);
end

always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
    begin
    req_r1  <= 1'b0;
    idata_r <= 16'd0;
    end
else if(bck_fall)
    begin
    req_r1  <= req_r;
    idata_r <= req_r1 ? idata : idata_r<<1;
    end
end

always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
    HP_DIN_r <= 1'b0;
else if(bck_fall)
    HP_DIN_r <= idata_r[15];
end

always@(posedge clk or negedge rst_n)
begin
if(!rst_n)
    HP_WS_r <= 1'b0;
else if(bck_fall)
    // Philips I2S (MAX98357A): WS toggles one BCK before the MSB (L MSB goes out at b_cnt LAT, R MSB at 16+LAT)
    HP_WS_r <= (b_cnt == LAT-1) ? 1'b0 : ((b_cnt == 16+LAT-1) ? 1'b1 : HP_WS_r);
end

endmodule
