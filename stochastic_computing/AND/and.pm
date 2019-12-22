//------------------------------
// Stochastic AND gate model
//------------------------------

dtmc

const double epsilon0=0.25;
const double epsilon1=0.75;

//------------------
// Signal Sources
//------------------
module Source0
  x0 : [-1..1] init 0;

  [] (x0=-1 | x0=1) -> epsilon0:(x0'=1) + (1-epsilon0):(x0'=-1);
endmodule


// Duplicate signal source:
module Source1 = Source0 [ x0=x1, epsilon0=epsilon1 ] endmodule



//------------------
// AND gate
//------------------
module AND0

  a0 : [-1..1] init -1;
  
  [] (x0=1 & x1=1)   -> (a0'=1);
  [] (x0=-1 | x1=-1) -> (a0'=-1);
  
endmodule


module Counter0

   c0: [-127..127] init 0;

   [] (c0>-127) & (c0<127)  -> (c0' = c0+a0);
   [] (c0 = 127) & (a0=1)   -> (c0' = c0);
   [] (c0 = 127) & (a0=-1)  -> (c0' = c0-1);
   [] (c0 = -127) & (a0=-1) -> (c0' = c0);
   [] (c0 = -127) & (a0=1)  -> (c0' = c0+1);


endmodule

// Expected convergence: c0/t0 = epsilon0*epsilon1 as t0 goes toward infinity

