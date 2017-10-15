// EEM16 - Logic Design
// Design Assignment #1 - Problem #2
// dassign1_2.v
module dassign1_2 (y,z,a,b,c,d,e);
    output y,z;
    input a,b,c,d,e;
  
  assign y = (~b | c); //problem 4a
  assign z = ((a & b & ~c) | ~(a & ~(~b&c)) | ~(~d|e) & c); // problem 4b

endmodule