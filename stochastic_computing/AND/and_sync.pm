//----------------------------------
// Stochastic AND gate model
//----------------------------------
// Unipolar representation
// stochatic multiplier
//
// Expected behavior:
//    Pr(c0=1) = epsilon0*epsilon1
//-----------------------------------

dtmc

const double epsilon0=0.25;
const double epsilon1=0.75;

//------------------
// Signal Sources
//------------------
module Source0
  x0 : [0..1] init 0;

  [event] (x0=0 | x0=1) -> epsilon0:(x0'=1) + (1-epsilon0):(x0'=0);
endmodule


// Duplicate signal source:
module Source1 = Source0 [ x0=x1, epsilon0=epsilon1 ] endmodule



//------------------
// AND gate
//------------------
module AND0

  a0 : [0..1] init 0;
  
  [event] (x0=1 & x1=1)  -> (a0'=1);
  [event] (x0=0 | x1=0)  -> (a0'=0);
  
endmodule


module Counter0

   c0: [0..127] init 0;
   
   [event] (c0 < 127) -> (c0' = c0 + a0);
   [event] (c0 = 127) -> (c0' = c0);

endmodule


module elapsedTime

   t0: [0..127] init 0;

   [event] (t0 < 127) -> (t0' = t0 + 1);
endmodule


