`timescale 1ns / 1ps

module Decimal_CLA(Clk,Cin,a,b,Sum,Cout,seg,an);
input Cin,Clk;
output [6:0]seg;
output [3:0]an;
input [3:0] a,b;
output reg [3:0] Sum;
output reg Cout;
reg [4:0]k;
//output [6:0]seg;
//output [3:0]an;

wire [3:0] Sum_t;
wire Cout_t;
wire A1,A2, O2;
reg Cout1;
reg[3:0]Sum1;
reg c = 1'b0;
reg [3:0] m =  4'b0110;
wire [4:0] X;
wire Y;
wire O1;

Four_bit_CLA DUT1(Cin,a,b,Sum_t,Cout_t);

 and a1(A1,Sum_t[3],Sum_t[2]);
 and a2(A2,Sum_t[3],Sum_t[1]);
 or or1(O2,Cout_t,A1);
 or or2(O1,O2,A2);
 
Four_bit_CLA DUT2(c,m,Sum_t,X,Y);

 always @(*)
 begin
 k={Cout_t,Sum_t};
  if (O1==1'b1)
    begin
    if(k>15) begin
     Sum=X;
     Cout=1'b1;
    end
    else begin
      Sum = X;
      Cout = Y;
    end
   end
   else begin
      Sum = Sum_t;
      Cout = Cout_t;
    end
end

endmodule

module Four_bit_CLA(Cin,a,b,Sum,Cout);
input Cin;
input [3:0]a,b;
wire [3:0]p,g,c;
output Cout;
output [3:0]Sum;

assign p[0]=(a[0]^b[0]),p[1]=(a[1]^b[1]),
       p[2]=(a[2]^b[2]),p[3]=(a[3]^b[3]);
assign g[0]=(a[0]&b[0]),g[1]=(a[1]&b[1]),
       g[2]=(a[2]&b[2]),g[3]=(a[3]&b[3]);
assign c[0]=Cin,c[1]=g[0]|(p[0]&Cin),
       c[2]=g[1]|(p[1]&g[0])|(p[1]&p[0]&Cin),
       c[3]=g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[1]&p[1]&p[0]&Cin),
       Cout=g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0])|(p[3]&p[2]&p[1]&p[0]&Cin);
assign Sum[0]=p[0]^c[0],Sum[1]=p[1]^c[1],
       Sum[2]=p[2]^c[2],Sum[3]=p[3]^c[3];

endmodule


