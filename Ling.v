`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////////

module Pgd(a,b,p,g,d);
input a,b;
output p,g,d;
xor(d,a,b);
and(g,a,b);
or(p,a,b);
endmodule

module group_PGl(input p0,g0,pi,gi, output P,G);
and(P,pi,p0);
or(G,g0,gi);
endmodule


module H_L(x,y,z,H);
input x,y,z;
output H;
wire q;
and(q,y,z);
or(H,q,x);
endmodule

module sum(H0,p0,di,sum);
input H0,p0,di;
output sum;
wire H2,q,x,y;
xor(q,p0,di);
not(H2,H0);
and(x,di,H2);
and(y,H0,q);
or(sum,x,y);
endmodule

module carry_L(Hi,Pi,C);
input Hi,Pi;
output C;
and(C,Hi,Pi);
endmodule




module ling(a,b,Cin,sum,carry);
input [7:0]a,b;
input Cin;
output [7:0]sum;
output carry;
wire [7:0]p,g,d;
wire [7:0]P,G,H;

Pgd f1(a[0],b[0],p[0],g[0],d[0]);
Pgd f2(a[1],b[1],p[1],g[1],d[1]);
Pgd f3(a[2],b[2],p[2],g[2],d[2]);
Pgd f4(a[3],b[3],p[3],g[3],d[3]);
Pgd f5(a[4],b[4],p[4],g[4],d[4]);
Pgd f6(a[5],b[5],p[5],g[5],d[5]);
Pgd f7(a[6],b[6],p[6],g[6],d[6]);
Pgd f8(a[7],b[7],p[7],g[7],d[7]);


group_PGl k1(p[0],g[0],1'b0,1'b0,P[0],G[0]);
group_PGl k2(p[1],g[1],p[0],g[0],P[1],G[1]);
group_PGl k3(p[2],g[2],p[1],g[1],P[2],G[2]);
group_PGl k4(p[3],g[3],p[2],g[2],P[3],G[3]);
group_PGl k5(p[4],g[4],p[3],g[3],P[4],G[4]);
group_PGl k6(p[5],g[5],p[4],g[4],P[5],G[5]);
group_PGl k7(p[6],g[6],p[5],g[5],P[6],G[6]);
group_PGl k8(p[7],g[7],p[6],g[6],P[7],G[7]);


H_L s1(G[0],1'b0,1'b0,H[0]);
H_L s2(G[1],P[0],1'b0,H[1]);
H_L s3(G[2],P[1],G[0],H[2]);
H_L s4(G[3],P[2],G[1],H[3]);
H_L s5(G[4],P[3],G[2],H[4]);
H_L s6(G[5],P[4],G[3],H[5]);
H_L s7(G[6],P[5],G[4],H[6]);
H_L s8(G[7],P[6],G[5],H[7]);

sum x1(d[0],1'b0,d[0],sum[0]);
sum x2(H[0],p[0],d[1],sum[1]);
sum x3(H[1],p[1],d[2],sum[2]);
sum x4(H[2],p[2],d[3],sum[3]);
sum x5(H[3],p[3],d[4],sum[4]);
sum x6(H[4],p[4],d[5],sum[5]);
sum x7(H[5],p[5],d[6],sum[6]);
sum x8(H[6],p[6],d[7],sum[7]);


carry_L j1(H[7],p[7],carry);

endmodule
