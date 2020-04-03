// TFF.pm
//
// CTMC model of an asyncronous delay-dependent
// bit source processed by a Toggle Flip Flop.
//

ctmc

const double Tstep;
const double R0;
const double R1=100-R0;

const double R_TFF;

// Bit stream B0 alternates between
// 1 and 0 with specified rates
module bit_source0
   B0 : [0..1] init 0;

   [] B0=0 -> R1:(B0'=1);
   [] B0=1 -> R0:(B0'=0);
endmodule


// TFF
module TFF0

   Q : [0..1] init 0;

   [] (B0=1) -> R_TFF:(Q'=1-Q);

endmodule