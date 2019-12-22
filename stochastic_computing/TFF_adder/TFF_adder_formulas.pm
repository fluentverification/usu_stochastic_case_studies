// ==================================================
// TFF_adder_formulas
// ==================================================
//   parameters:
//      pA    -- statistic for bitstream A
//      pB    -- statistic for bitstream B
//      Tstep -- dummy parameter for property spec
// ==================================================
// Stochastic adder based on toggle flip-flop
// for unipolar and bipolar formats. This version
// uses formulas to model combinational logic with
// zero delay. This works as a general model for 
// synchronous logic circuits.
//
// Output should be Pr(Z) = 0.5(pA + pB)
// ==================================================

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


//--------------------------------------------
// XOR and MUX formulas (combinational logic)
//--------------------------------------------
formula xor=(inA=1 & inB=0) | (inA=0 & inB=1);
formula mux=(xor & Q=1) | (!xor & inB=1);
//formula Z=(xor & Q=1) | (!xor & inB=1);


//--------------------------------------------
// TFF Module
//--------------------------------------------
module TFF
//   Z : [0..1] init 0;
   Q : [0..1] init 0;
  
   [event] (xor) -> (Q' = 1-Q);
   [event] (!xor) -> (Q' = Q);

endmodule


//--------------------------------------------
// Output Register
//--------------------------------------------
module REG0
   Z : [0..1] init 0;

   [event] (mux)  -> (Z'=1);
   [event] (!mux) -> (Z'=0);
endmodule

