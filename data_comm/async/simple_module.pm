ctmc 
module producer 

valid: [0..1] init 0; 

[] (rdy = 0) & (valid = 1) -> .1:(valid' = 0); 

[] (rdy = 0) & (valid = 0) -> .1:(valid' = 1); 

[Faultvalid1] (valid = 1) -> .001:(valid' = 0); 

[Faultvalid2] (valid = 0) -> .001:(valid' = 1);

endmodule 


module consumer 

done: [0..1] init 0; 

[] (ack = 1) & (done = 0) -> .1:(done' = 1); 

[] (ack = 0) & (done = 1) -> .1:(done' = 0);

[Faultdone1] (done = 1) -> .001:(done' = 0);

[Faultdone2] (done = 0) -> .001:(done' = 1);

endmodule 


module sender 

rdy: [0..1] init 0; 

[] (valid = 1) & (ack = 0) & (rdy = 0) -> 1:(rdy' = 1); 

[] (rdy = 1) & (ack = 1) -> 1:(rdy' = 0);

[Faultrdy1] (rdy = 1) -> .001:(rdy' = 0);

[Faultrdy2] (rdy = 0) -> .001:(rdy' = 1);

endmodule 


module reciever 

ack: [0..1] init 0; 

[] (rdy = 1) & (ack = 0) & (done = 0) -> 1:(ack' = 1); 

[] (rdy = 0) & (done = 1) & (ack = 1) -> 1:(ack' = 0); 

[Faultack1] (ack = 1) -> .001:(ack' = 0);

[Faultack2] (ack = 0) -> .001:(ack' = 1);


endmodule 

rewards
	[Fault] true:1;
endrewards
