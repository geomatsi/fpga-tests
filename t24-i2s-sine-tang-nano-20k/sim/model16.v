// Behavioral CORDIC_Top model for Icarus: stand-in for the encrypted Gowin IP
// (src/cordic/cordic.vo), configured as in src/cordic/cordic.ipc:
//   ROTATE, RADIAN, Q2.15 x/y/theta, gain G not compensated,
//   latency = 16: x_o/y_o change 16 edges after theta_i changes (IPUG522 Fig 4-3)
module CORDIC_Top(input clk,rst,input signed [16:0] x_i,y_i,theta_i,output signed [16:0] x_o,y_o,theta_o);
  real G = 1.646760258; real th;
  reg signed [16:0] xp[0:15], yp[0:15]; integer i;
  always @(posedge clk) begin
    th = $itor(theta_i)/32768.0;
    xp[0] <= $rtoi(G*($itor(x_i)*$cos(th) - $itor(y_i)*$sin(th)));
    yp[0] <= $rtoi(G*($itor(x_i)*$sin(th) + $itor(y_i)*$cos(th)));
    for (i=1;i<16;i=i+1) begin xp[i]<=xp[i-1]; yp[i]<=yp[i-1]; end
  end
  assign x_o = xp[15]; assign y_o = yp[15]; assign theta_o = 0;
endmodule
