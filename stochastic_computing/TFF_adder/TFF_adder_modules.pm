// ==================================================
// TFF_adder_modules
// ==================================================
//   parameters:
//      pA    -- statistic for bitstream A
//      pB    -- statistic for bitstream B
//      Tstep -- dummy parameter for property spec
// ==================================================
// Stochastic adder based on toggle flip-flop
// for unipolar and bipolar formats. This version
// uses distinct modules for XOR and MUX gates,
// allowing for fault injection in those modules.
//
// Output should be Pr(Z) = 0.5(pA + pB)
// ==================================================

dtmc

const double pA;
const double pB;
const int Tstep;

//-----------------------------------
// Signal Sources
//-----------------------------------
module SourceA
  inA : [0..1] init 0;

  [event] (clk=1) -> pA:(inA'=1) + (1-pA):(inA'=0);
  [event] (clk=0) -> (inA'=inA);
endmodule

module SourceB = SourceA [inA = inB, pA = pB] endmodule


//-----------------------------------
// Clock
//-----------------------------------
// Always toggles
//-----------------------------------
module CLK0

   clk : [0..1] init 0;

   [event] (true) -> (clk' = 1-clk);

endmodule


//-----------------------------------
// Toggle Flip-Flop (TFF)
//-----------------------------------
// Sensitive to positive clock edge
//-----------------------------------
module TFF
   Q : [0..1] init 0;
  
   [event] (clk=1 & T=0) -> (Q' = Q);
   [event] (clk=1 & T=1) -> (Q' = 1-Q);
   [event] (clk=0)       -> (Q' = Q);
endmodule


//-----------------------------------
// XOR gate
//-----------------------------------
// Sensitive to negative clock edge
//-----------------------------------
module XOR0

  T : [0..1] init 0;
  
  [event] (clk=0) & ((inA=1 & inB=0) | (inA=0 & inB=1))  -> (T'=1);
  [event] (clk=0) & ((inA=1 & inB=1) | (inA=0 & inB=0))  -> (T'=0);
  [event] (clk=1) -> (T' = T);
  
endmodule


//-----------------------------------
// MUX
//-----------------------------------
// Sensitive to positive clock edge
//-----------------------------------
module MUX0

   Z : [0..1] init 0;

   [event] (clk=1) & (T=1) -> (Z' = Q);
   [event] (clk=1) & (T=0) -> (Z' = inB);
   [event] (clk=0) -> (Z' = Z);
endmodule

