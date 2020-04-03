//====================================
// async_ratioed_multiplier.pm
//====================================
// Chris Winstead, Jan 2020
// Utah State University
// chris.winstead@usu.edu
//====================================
// Description:
// ------------
// Implements a multiplier for stochastic 
// numbers in the likelihood ratio format.
// Uses asynchronous gates with random
// delays.

ctmc

// Placeholder for time step, used for 
// dynamic analysis
const double Tstep;

// Input likelihood ratios:
const double l_A;
const double l_B;

const double R_AND = 10;
const double R_OR  = 10;
const double R_MUX = 10;
const double R_REG;

module sourceA
  b_A : [0..1] init 0;

  [] (b_A=0) -> (100*l_A/(1+l_A)):(b_A' = 1);
  [] (b_A=1) -> (100*(1-l_A/(1+l_A))):(b_A' = 0);
endmodule

module sourceB = sourceA [b_A = b_B, l_A = l_B] endmodule

module AND0
  b_AB : [0..1] init 0;

  [] (b_A=1 & b_B=1) -> R_AND:(b_AB'=1);
  [] (b_A=0 | b_B=0) -> R_AND:(b_AB'=0);
endmodule


module OR0
  b_AorB : [0..1] init 0;

  [] (b_A=1 | b_B=1) -> R_OR:(b_AorB'=1);
  [] (b_A=0 & b_B=0) -> R_OR:(b_AorB'=0);
endmodule


module MUX0
   b_M : [0..1] init 0;

   [] (Q = 1) -> R_MUX:(b_M' = b_AorB);
   [] (Q = 0) -> R_MUX:(b_M' = b_AB);
endmodule


module REG0
  Q : [0..1] init 0;

  [] (true) -> R_REG:(Q' = b_M);
endmodule