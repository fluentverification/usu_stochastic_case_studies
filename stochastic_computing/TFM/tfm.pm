

// somewhere I have integer C and T, such that C/T is a probability

dtmc

const double epsilon0;// = 0.75;
const double beta     = 0.0625;

//------------------
// Signal Sources
//------------------
module Source0
  x0 : [0..1] init 0;

  [event] (x0=0 | x0=1) -> epsilon0:(x0'=1) + (1-epsilon0):(x0'=0);
endmodule



// ...
module someModule

  q : [0..1] init 0;

  [event] (c0>=0) -> (c0/127):(q' = 1) + (1-c0/127):(q'=0);
//  [event] (c0=0) -> (q'=0);

endmodule


module TFM0

   c0: [0..127] init 0;

   [event] (c0 >= 0) & (c0 <= 127) -> (c0' = round(c0*(1-beta)) + round(127*x0*beta));

endmodule


