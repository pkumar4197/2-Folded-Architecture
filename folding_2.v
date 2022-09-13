`timescale 1ns / 1ps
//Y[n] = a*Y[n-3] + b*Y[n-5] + X[n] IIR Filter


module folding_2(Xn,Yn,a,b,clk,switch,rst);

parameter n=16;
input [n-1:0]Xn,a,b;
input clk,switch,rst;
output reg [n-1:0]Yn;

wire signed [n-1:0]w[1:15];

//adder and multiplier
mult_16X16 M(w[14],w[9],w[10]);      // w[10]=w[14]*w[9];
ripplemod add( w[1],w[15], 0, w[2], ); // w[2]=w[1]+w[15];


//mux instantiation
mux u1(w[12],Xn,w[1],switch);
mux u2(w[13],w[3],w[15],switch);
mux u3(w[5],w[8],w[9],switch);
mux u4(a,b,w[14],switch);


//delay instantiation
delay d1(w[2],w[3],clk,rst);
delay d2(w[3],w[4],clk,rst);
delay d3(w[4],w[5],clk,rst);
delay d4(w[5],w[6],clk,rst);
delay d5(w[6],w[7],clk,rst);
delay d6(w[7],w[8],clk,rst);
delay d7(w[10],w[11],clk,rst);
delay d8(w[11],w[12],clk,rst); 
delay d9(w[12],w[13],clk,rst);


//output
always@(posedge clk)
if(switch==0)
 Yn=w[3];

endmodule


// full adder 
module fulladd(a, b, cin, sum, cout);
input a,b,cin;
output sum,cout;

assign sum=(a^b^cin);
assign cout=((a&b)|(b&cin)|(a&cin));

endmodule


//ripple carry adder
module ripplemod(a, b, cin, sum, cout);
input [15:0] a;
input [15:0] b;
input cin;
output [15:0]sum;
output cout;

wire[14:0] c;

fulladd a1(a[0],b[0],cin,sum[0],c[0]);

fulladd aa[15:2](a[14:1],b[14:1],c[13:0],sum[14:1],c[14:1]);
fulladd a16(a[15],b[15],c[14],sum[15],cout);
endmodule


// mux 2x1
module mux(i0,i1,out,s);

parameter n=16;
input [n-1:0]i0,i1;
input s;
output reg [n-1:0]out;
always@(s)
begin
	out=s?i1:i0;
end
endmodule

// Delay using DFF
module delay(in,out,clk,rst);
parameter n=16;
input [n-1:0]in;
output reg [n-1:0]out;
input clk,rst;

always@(posedge clk)
begin
	out=rst?0:in;
end
endmodule

//Multiplier module

module mult_16X16(a,b,y

    );

    input [15:0] a, b;
    output  [15:0] y;
    wire    [15:0] ab0 = a & {16{b[0]}};
    wire    [15:0] ab1 = a & {16{b[1]}};
    wire    [15:0] ab2 = a & {16{b[2]}};
    wire    [15:0] ab3 = a & {16{b[3]}};
    wire    [15:0] ab4 = a & {16{b[4]}};
    wire    [15:0] ab5 = a & {16{b[5]}};
    wire    [15:0] ab6 = a & {16{b[6]}};
    wire    [15:0] ab7 = a & {16{b[7]}};
    wire    [15:0] ab8 = a & {16{b[8]}};
    wire    [15:0] ab9 = a & {16{b[9]}};
    wire    [15:0] ab10 = a & {16{b[10]}};
    wire    [15:0] ab11 = a & {16{b[11]}};
    wire    [15:0] ab12 = a & {16{b[12]}};
    wire    [15:0] ab13 = a & {16{b[13]}};
    wire    [15:0] ab14 = a & {16{b[14]}};
    wire    [15:0] ab15 = a & {16{b[15]}};

    // 32 terms
  
    assign y = ({16'b1, ~ab0[15], ab0[14:0]}
               +{15'b0, ~ab1[15], ab1[14:0],1'b0}
               +{14'b0, ~ab2[15], ab2[14:0],2'b0}
               +{13'b0, ~ab3[15], ab3[14:0],3'b0}
               +{12'b0, ~ab4[15], ab4[14:0],4'b0}
               +{11'b0, ~ab5[15], ab5[14:0],5'b0}
               +{10'b0, ~ab6[15], ab6[14:0],6'b0}
               +{9'b0,  ~ab7[15], ab7[14:0],7'b0}
                 +{8'b0,~ab8[15], ab8[14:0],8'b0}
                +{7'b0, ~ab9[15], ab9[14:0],9'b0}
               +{6'b0, ~ab10[15], ab10[14:0],10'b0}
               +{5'b0, ~ab11[15], ab11[14:0],11'b0}
                +{4'b0,~ab12[15], ab12[14:0],12'b0}
              + {3'b0, ~ab13[15], ab13[14:0],13'b0}
               +{2'b0, ~ab14[15], ab14[14:0],14'b0}
               + {1'b1, ab15[15],~ab15[14:0],15'b0});

endmodule