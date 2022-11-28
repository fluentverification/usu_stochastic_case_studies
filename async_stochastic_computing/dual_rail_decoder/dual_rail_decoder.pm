// Dual-rail decoder
//Greater description of model is necessary.
// Signal encoding:
//   0: logic 0
//   1: logic 1
//   2: pending

ctmc

const double signal_rate = 100;
const double gate_rate   = 1000;



const double p0;
//const double p1 = 0.55;
const double p2;



// Bit stream sources
module bit_source0
   B0 : [0..2] init 2;

   [] (B0=0 | B0=1) -> signal_rate:(B0'=2);
   [] B0=2 -> p0*gate_rate:(B0'=1) + (1-p0)*gate_rate:(B0'=0);
endmodule

//module bit_source1 = bit_source0 [B0=B1, p0=p1] endmodule
//module bit_source2 = bit_source0 [B0=B2, p0=p2] endmodule

module bit_source3 = bit_source0 [B0=Q2, p0=p2] endmodule


// Symbol nodes
module sym0
   Q0 : [0..2] init 2;
   C0 : [0..7] init 0;

   //[] (B0 = 2) | (B1 = 2) -> gate_rate:(Q0' = 2);
   [] (B0 = 1) & (Q2 = 1) & (Q0 = 2) -> gate_rate:(Q0' = 1) ;
   [] (B0 = 0) & (Q2 = 0) & (Q0 = 2) -> gate_rate:(Q0' = 0) ;
   [] (B0 = 1) & (Q2 = 1) & (Q0 = 2) & (C0 > 0) -> gate_rate:(C0' = 0);
   [] (B0 = 0) & (Q2 = 0) & (Q0 = 2) & (C0 > 0) -> gate_rate:(C0' = 0);
   [] (B0 = 0) & (Q2 = 0) & (Q0 = 1) -> gate_rate:(Q0' = 2);
   [] (B0 = 1) & (Q2 = 1) & (Q0 = 0) -> gate_rate:(Q0' = 2);
   [] (B0 != Q2)                     -> gate_rate:(Q0' = 2);
   [] (Q0 = 2) & (C0 < 2) & (B0 = 2) -> gate_rate:(C0' = C0 + 1);
   [] (Q2 = 2) & (C0 = 2)            -> gate_rate:(Q0' = B0);
endmodule

//module sym1 = sym0 [Q0=Q1,B0=B1,Q2=Q0, C0=C1] endmodule
//module sym2 = sym0 [Q0=Q2,B0=B2,Q2=Q1, C0=C2] endmodule
