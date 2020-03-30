// C_element.pm
//
// CTMC model of an asyncronous delay-dependent
// bit source processed by a Muller C-element.
//

ctmc

const double Tstep;
const double R00;
const double R01=100-R00;
const double R10;
const double R11=100-R10;

const double R_CEM;

// Bit stream B0 alternates between
// 1 and 0 with specified rates
module bit_source0
   B0 : [0..1] init 0;

   [] B0=0 -> R01:(B0'=1);
   [] B0=1 -> R00:(B0'=0);
endmodule

module bit_source1 = bit_source0 [B0=B1, R01=R11, R00=R10] endmodule



// C-element
module CEM0

   Q : [0..1] init 0;

   [] (B0=1 & B1=1) -> R_CEM:(Q'=1);
   [] (B0=0 & B1=0) -> R_CEM:(Q'=0);

endmodule