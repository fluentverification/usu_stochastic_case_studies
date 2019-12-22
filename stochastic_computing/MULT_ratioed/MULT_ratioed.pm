// ==================================================
// MULT_ratioed
// ==================================================
//   parameters:
//      pA    -- statistic for bitstream A
//      pB    -- statistic for bitstream B
//      Tstep -- dummy parameter for property spec
// ==================================================
// Stochastic multiplier for ratioed numbers.
// Input values are:
//
//    A = pA/(1-pA)
//    B = pB/(1-pB)
//
// Output should be C = A*B
//        with pC = pA*pB/(1 - pA - pB + 2pApB)
// ==================================================

dtmc

const double nA;
const double nB;
const int Tstep;

const double pA = nA/(1+nA);
const double pB = nB/(1+nB);

//--------------------------------------------
// Signal Sources
//--------------------------------------------
module SourceA
  inA : [0..1] init 0;

  [event] (inA=0 | inA=1) -> pA:(inA'=1) + (1-pA):(inA'=0);
endmodule

module SourceB = SourceA [inA = inB, pA = pB] endmodule



//-------------------------------------------------
// AND, OR and MUX formulas (combinational logic)
//-------------------------------------------------
formula and=(inA=1 & inB=1);
formula mux=(Z=1 & or) | (Z=0 & and);
formula or=(inA=1 | inB=1);


//--------------------------------------------
// Output Register
//--------------------------------------------
module REG0
   Z : [0..1] init 0;

   [event] (mux)  -> (Z'=1);
   [event] (!mux) -> (Z'=0);
endmodule
