// EEM16 - Logic Design
// Design Assignment #1 - Problem #3
// dassign1_3.v
module dassign1_3(y,x);
   output y;
   input [3:0] x;
   reg y;
  always @(x) begin
    case(x)
      4'b0000: assign y = 0;
      4'b0001: assign y = 0;
      4'b0010: assign y = 0;
      4'b0011: assign y = 1;
      4'b0100: assign y = 0;
      4'b0101: assign y = 0;
      4'b0110: assign y = 1;
      4'b0111: assign y = 1;
      4'b1000: assign y = 0;
      4'b1001: assign y = 1;
      4'b1010: assign y = 1;
      4'b1011: assign y = 1;
      4'b1100: assign y = 0;
      4'b1101: assign y = 0;
      4'b1110: assign y = 0;
      4'b1111: assign y = 0;
    endcase
  end
endmodule