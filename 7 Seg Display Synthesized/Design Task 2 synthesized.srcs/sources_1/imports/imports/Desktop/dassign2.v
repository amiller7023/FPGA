`timescale 1ns/100ps


////////////////////////////////////////////////////////////////
//  module for add/subtract of a signal decimal digit
////////////////////////////////////////////////////////////////
module deciadd (digInA, digInB, sub, cin, digOut, cout);
////////////////////////////////////////////////////////////////
//  parameter declarations
////////////////////////////////////////////////////////////////
parameter dlen=3;
////////////////////////////////////////////////////////////////
//  input/output declarations
////////////////////////////////////////////////////////////////
input   [dlen:0]   digInA, digInB;
input   sub, cin;
output  [dlen:0]  digOut;
output  cout;


////////////////////////////////////////////////////////////////
//  reg & wire declarations
////////////////////////////////////////////////////////////////
reg [dlen:0] digOut;
reg cout;
  reg[dlen + 1:0] S;
  reg[dlen:0] A, B;
  
  always @(sub or cin or digInA or digInB)
    begin
       A = digInA;
    	if(sub)
      		 B = 4'b1001 - digInB;
  		else
    		 B = digInB;
      
   S = A + B + cin;
      
       digOut = (S < 5'b01010) ? S : S - 4'b1010; 
      
       cout = (S < 5'b01010) ? 1'b0 : 1'b1;
    end

endmodule

module dassign2 (//clk, 
//btnC, 
//seg, 
//an, 
//dp, 
wdinA, wdinB, sub, wdout, ovunflow);
////////////////////////////////////////////////////////////////
//  parameter declarations
////////////////////////////////////////////////////////////////
parameter wlen=15;
parameter dlen=3;
	
////////////////////////////////////////////////////////////////
//  input/output declarations
////////////////////////////////////////////////////////////////
input   [wlen:0]   wdinA;
input   [wlen:0]   wdinB;
//input clk;
//input btnC;
//output [6:0]  seg;
//output [3:0] an;
//output dp;
input   sub;
output  [wlen:0]  wdout;
output  ovunflow;

////////////////////////////////////////////////////////////////
//  reg & wire declarations
////////////////////////////////////////////////////////////////
reg   [wlen:0]   out;
wire [dlen:0] d1inA, d2inA, d3inA, d4inA;
wire [dlen:0] d1inB, d2inB, d3inB, d4inB;
wire [dlen:0] d1out, d2out, d3out, d4out;
reg cin;
wire cout1,cout2,cout3,cout4;

////////////////////////////////////////////////////////////////
//  Combinational Logic - do NOT change this 
//     *We may check these internal signals*
////////////////////////////////////////////////////////////////
assign {d4inA,d3inA,d2inA,d1inA} = wdinA;
assign {d4inB,d3inB,d2inB,d1inB} = wdinB;

assign wdout = {d4out,d3out,d2out,d1out};

deciadd dig1(d1inA, d1inB, sub, cin, d1out, cout1);
deciadd dig2(d2inA, d2inB, sub, cout1, d2out, cout2);
deciadd dig3(d3inA, d3inB, sub, cout2, d3out, cout3);
deciadd dig4(d4inA, d4inB, sub, cout3, d4out, cout4);

reg ovunflow;
reg firstpos, secpos, respos;
reg[3:0] signs;
  
  always @(sub or cin or cout4 or cout3 or d4inA or d4inB or d4out) begin
    begin
    	if(sub)
      cin = 1'b1;
  		else
    	 cin = 1'b0;
    end
  
      if(d4inA < 4'b0101)
        firstpos = 1'b1;
      else
        firstpos = 1'b0;
    
      if(d4inB < 4'b0101)
        secpos = 1'b1;
      else
        secpos = 1'b0;
    
      if(d4out < 4'b0101)
        respos = 1'b1;
      else
        respos = 1'b0;
    signs = {sub, firstpos, secpos, respos};
    
    case(signs)
      4'b0110:
        ovunflow = 1'b1; //pos + pos = neg 
      4'b0001:
        ovunflow = 1'b1; //neg + neg = pos
      4'b1100:
        ovunflow = 1'b1; //pos - neg = neg
      4'b1011:
        ovunflow = 1'b1; //neg - pos = pos
      default: 
        ovunflow = 1'b0; //none of the above
    endcase
      
  end
 
endmodule

 module Top(

//CLK Input
	 input clk,
	 
//Push Button Inputs	 
	 input btnC,
	 input btnU, 
	 input btnD,
	 input btnR,
	 input btnL,
	 
// Slide Switch Inputs
// Input A = sw[15:8]
//Input B = sw[7:0]	 
	 input [15:0] sw, 
   
// LED Outputs
     output led,
     
// Seven Segment Display Outputs
     output [6:0] seg,
     output [3:0] an, 
     output dp
    
 );
	
//Seven Segment Display Signal
wire [15:0] x;//input to seg7 to define segment pattern
// 7segment display module

Buttons u1(
  .sw(sw),
  .left(btnL),
  .right(btnR),
  .up(btnU),
  .down(btnD),
  .x(x),
  .led(led)
  );
  
  seg7decimal u3 (
  .x(x),
  .clk(clk),
  .clr(btnC),
  .a_to_g(seg),
  .an(an),
  .dp(dp)
  );
  

endmodule

module Buttons(input [15:0] sw,
 input left, 
 input right, 
 input up, 
 input down, 
 output[15:0] x,
 output led
  );

reg sub;
reg[15:0] wdinA, wdinB;
wire[15:0] inputA, inputB;
wire subt;
assign inputA = wdinA;
assign inputB = wdinB;
assign subt = sub; 

dassign2 u2(
 .wdinA(inputA),
 .wdinB(inputB),
 .sub(subt),
  .wdout(x), 
  .ovunflow(led)
  );

always @(left or right or up or down or sw) begin
if(left == 1)
    begin
    wdinA = sw;
    end
else if (right == 1)
    begin
    wdinB = sw;
    end
else if(down == 1)
    begin 
    sub = 1;
    end
else if(up == 1)
    begin
    sub = 0;
    end
else
begin
    wdinA = wdinA;
    wdinB = wdinB;
end
end
endmodule

