// DIV2
// Unipolar Stochastic Divide-By-2
// Based on Toggle Flip-Flop

dtmc

const double epsilon0;
const int Tstep;

//------------------
// Signal Sources
//------------------
module Source0
  x0 : [0..1] init 0;

  [event] (x0=0 | x0=1) -> epsilon0:(x0'=1) + (1-epsilon0):(x0'=0);
endmodule



//------------------------
// Toggle Flip-Flop (TFF)
//------------------------
module TFF
   T : [0..1] init 0;
  
   [event] (x0=0) -> (T' = T);
   [event] (x0=1) -> (T' = 1-T);

endmodule


//------------------
// AND gate
//------------------
module AND0

  Q : [0..1] init 0;
  
  [event] (x0=1 & T=1)  -> (Q'=1);
  [event] (x0=0 | T=0)  -> (Q'=0);
  
endmodule
