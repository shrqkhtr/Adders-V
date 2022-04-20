`timescale 1ns / 1ps

module PG(a,b,p,g);
input a,b;
output p,g;
xor(p,a,b);
and(g,a,b);
endmodule

module group_PG(input p0,g0,pi,gi, output P,G);
wire q;
and(P,pi,p0);
and(q,pi,g0);
or(G,q,gi);
endmodule

//Half adder
module ha(a,b,sum,carry);
input a,b;
output sum,carry;
xor(sum,a,b);
and(carry,a,b);
endmodule

//full adder
module fa(a,b,c,sum,carry);
input a,b,c;
output sum,carry;
  wire x,y,z;
  ha h1(a,b,x,y);
  ha h2(x,c,sum,z);
  or(carry,y,z);
endmodule



module STA(a,b,Cin,sum, carry);
//input clk;
input [7:0]a,b;
input Cin;
output [7:0]sum;
output carry;
//output[6:0] seg;
//output[3:0] an;

wire [3:0]p,g;
wire [1:0]P,G;
wire x,y,z,C4;
wire [7:0]c;

//obtain PG till 4th
PG F1(a[0],b[0],p[0],g[0]);
PG F2(a[1],b[1],p[1],g[1]);
PG F3(a[2],b[2],p[2],g[2]);
PG F4(a[3],b[3],p[3],g[3]);

//evaluating group PG
group_PG f1(p[0],g[0],p[1],g[1],P[0],G[0]);
group_PG f2(p[2],g[2],p[3],g[3],P[1],G[1]);

//final group PG
group_PG K1(P[0],G[0],P[1],G[1],x,y);

//calculate carry for 4th
and(z,Cin,x);
or(C4,y,z);



fa m1(a[0],b[0],Cin,sum[0],c[1]);
fa m2(a[1],b[1],c[1],sum[1],c[2]);
fa m3(a[2],b[2],c[2],sum[2],c[3]);
fa m4(a[3],b[3],c[3],sum[3],c[4]);

fa m5(a[4],b[4],C4,sum[4],c[5]);
fa m6(a[5],b[5],c[5],sum[5],c[6]);
fa m7(a[6],b[6],c[6],sum[6],c[7]);
fa m8(a[7],b[7],c[7],sum[7],carry);

//Seven w1({carry,sum},clk,seg,an);



endmodule


module Seven(a,clk,seg,an);
input [8:0]a;
input clk;
output reg [6:0]seg;
output reg [3:0]an;
reg[31:0]t=0;
reg [3:0]st=0;
reg tclk=0;
 reg [1:0]c=0;
integer w,k;

initial begin
w<=a;
end

always@(posedge clk) begin
t=t+1;
if(t==500000) begin
tclk=~tclk;
t=0;
end
end

//always@(a) begin
//         w=a;
//         end


always@(posedge tclk) begin
an=4'b1111;
if(w>0)
        begin
        k=(w%10);
        st=k;
        w=(w/10);
        an[c]=0;
        c=c+1;
        end
        else begin
        w=a;
        c=0;
        end
end

always@(st)
case(st)
4'b0000:seg=7'b0000001;   
4'b0001:seg=7'b1001111;   
4'b0010:seg=7'b0010010;   
4'b0011:seg=7'b0000110;   
4'b0100:seg=7'b1001100;   
4'b0101:seg=7'b0100100;   
4'b0110:seg=7'b0100000;   
4'b0111:seg=7'b0001111;   
4'b1000:seg=7'b0000000;   
4'b1001:seg=7'b0000100; 
endcase 

endmodule
