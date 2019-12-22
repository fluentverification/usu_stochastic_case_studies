// bit_source.pm
//
// CTMC model of an asyncronous delay-dependent
// bit source.
//
// NOTE: need to use Gauss-Seidel method to get
// steady-state convergence 

ctmc

const double R0=90;
const double R1=10;

// Bit stream B0 alternates between
// 1 and 0 with specified rates
module bit_source
   B0 : [0..1] init 0;

   [] B0=0 -> R1:(B0'=1);
   [] B0=1 -> R0:(B0'=0);
endmodule

