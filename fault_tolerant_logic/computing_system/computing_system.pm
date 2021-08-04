ctmc

const double eps=1e-5;

module processor1
   pr1 : [0..1] init 0;

   [] (pr1 = 0) -> 5*eps :(pr1' = 1);
   [] (pr1 = 1) -> 30    :(pr1' = 0);
endmodule

module processor2 = processor1 [ pr1=pr2 ] endmodule


module bus1
   b1 : [0..1] init 0;

   [] (b1 = 0) -> 0.3*eps :(b1' = 1);
   [] (b1 = 1) -> 15      :(b1' = 0);
endmodule

module bus2 = bus1 [ b1=b2 ] endmodule


module disk1
   d1 : [0..1] init 0;

   [] (d1 = 0) -> 4*eps :(d1' = 1);
   [] (d1 = 1) -> 30    :(d1' = 0);
endmodule

module disk2 = disk1 [ d1=d2 ] endmodule


module fan1
   f1 : [0..1] init 0;

   [] (f1 = 0) -> 0.1*eps :(f1' = 1);
   [] (f1 = 1) -> 30      :(f1' = 0);
endmodule

module fan2 = fan1 [ f1=f2 ] endmodule


module powersupply1
   ps1 : [0..1] init 0;

   [] (ps1 = 0) -> 3*eps :(ps1' = 1);
   [] (ps1 = 1) -> 30    :(ps1' = 0);
endmodule

module powersupply2 = powersupply1 [ ps1=ps2 ] endmodule

module controller1
   c1 : [0..1] init 0;

   [] (c1 = 0) -> 2*eps :(c1' = 1);
   [] (c1 = 1) -> 30    :(c1' = 0);
endmodule


label "fail" =  ((pr1+pr2>1)|(ps1+ps2>1)|(c1=1)|(f1+f2>1)|(d1+d2>1)|(b1+b2>1));
label "allgood" = (pr1 + pr2 + ps1 + ps2 + c1 + f1 + f2 + d1 + d2 + b1 + b2 = 0);
formula fail =  ((pr1+pr2>1)|(ps1+ps2>1)|(c1=1)|(f1+f2>1)|(d1+d2>1)|(b1+b2>1));
formula  allgood = (pr1 + pr2 + ps1 + ps2 + c1 + f1 + f2 + d1 + d2 + b1 + b2 = 0);


rewards "return_to_zero"
    !allgood & !fail : 1;
endrewards
