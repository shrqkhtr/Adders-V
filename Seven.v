`timescale 1ns / 1ps


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
if(t==50000) begin
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
