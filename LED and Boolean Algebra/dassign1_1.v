// EEM16 - Logic Design
// Design Assignment #1 - Problem #1
// dassign1_1.v
module inverter(y,a);
    output y;
    input a;
  assign y = ~a;
endmodule

module nand2(y,a,b);
    output y;
    input a,b;
  wire c;
  assign c = ~(a & b);
  assign y = c;
endmodule

module nand3(y,a,b,c);
	output y;
    input a,b,c;
    wire d;
  assign d = ~(a & b & c);
   assign y = d;
endmodule

module nor2(y,a,b);
	output y;
    input a,b;
  wire c;
  assign c = ~(a | b);
  assign y = c;
endmodule

module nor3(y,a,b,c);
	output y;
    input a,b,c;
    wire d;
  assign d = ~(a | b | c);
   assign y = d;
endmodule

module mux2(y,a,b,sel);
  input sel;
  input a, b;
  output y;
  reg y;
  always @ (sel or a or b)
  begin
    if(sel) y = a;
    else y = b;
  end
endmodule

module xor2(y,a,b);
input a, b;
  output y;
  wire c = a | b;
  wire d = ~a | ~b;
  assign y = c & d;
endmodule

module dassign1_1 (y,a,b,c,d,e,f,g);
    output y;
    input a,b,c,d,e,f,g;
  wire y1, y2, y3, y4, y5, y6;
  nand3 one(y1, a, b, c);
  nand2 two(y2, y1, d);
  nand2 three(y3, f, g);
  nor2 four(y4, e, y3);
  nor2 five(y5, y2, y4);
  nor2 six(y6, y5, y5);
  assign y = y6;
endmodule