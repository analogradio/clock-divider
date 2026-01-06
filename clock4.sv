`default_nettype none
// Empty top module

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

logic hz4;
clock_4hz clk4 (.clk(hz100), .rst(reset), .hz4(hz4));
assign green = hz4; 
 
endmodule

module clock_4hz(input logic clk,input logic rst, output logic hz4 );

logic[7:0] Q;
logic[7:0] next_Q;
logic hz100;

always_ff @(posedge clk or posedge rst) begin
if (rst) 
 Q <= 8'b0;
  else
  Q <= next_Q;
end 

always_comb begin
  if(Q==8'd12) begin
    next_Q = 8'b0;
  end
else begin
  next_Q[0] = ~Q[0];
  next_Q[1] = ^Q[1:0];
  next_Q[2] = Q[2]^(&Q[1:0]);
  next_Q[3] = Q[3]^(&Q[2:0]);
  next_Q[4] = Q[4]^(&Q[3:0]);
  next_Q[5] = Q[5]^(&Q[4:0]);
  next_Q[6] = Q[6]^(&Q[5:0]);
  next_Q[7] = Q[7]^(&Q[6:0]);

end
end

always_ff @(posedge clk or posedge rst) begin
if (rst) 
 hz100 <= 1'b0;
  else if(Q==8'd12)
  hz100 <= 1'b1;
  else hz100 <= 0;
end 

always_ff @(posedge rst or posedge hz100) begin
if (rst) 
 hz4 <= 1'b0;
  else 
  hz4 <= ~hz4;
end 
endmodule
