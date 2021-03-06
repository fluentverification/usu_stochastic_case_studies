dtmc

const double pA;
const double pB;
const int Tstep;

//--------------------------------------------
// Signal Sources
//--------------------------------------------
module SourceA
  inA : [0..1] init 0;

  [event] (inA=0 | inA=1) -> pA:(inA'=1) + (1-pA):(inA'=0);
endmodule

module SourceB = SourceA [inA = inB, pA = pB] endmodule


module XOR0

  T : [0..1] init 0;

  [event] (inA=1 & inB=0) | (inA=0 & inB=1) -> (T' = 1);
  [event] (inA=0 & inB=0) | (inA=1 & inB=1) -> (T' = 0);

endmodule


module TFF

  Q : [0..1] init 0;

  [event] (T = 1) -> (Q' = 1-Q);
  [event] (T = 0) -> (Q' = Q);

endmodule


module MUX

  Z : [0..1] init 0;

  [event] (T = 1) -> (Z' = Q);
  [event] (T = 0) -> (Z' = inB);

endmodule
