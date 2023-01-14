
//Simple Handshaking model:
//Used to simulate an syncronous handshaking algorithm
//between a sender and a reciever. Model contains 4 signals
//that are used to control and faciliate the communictation 
//bewteen the two devices.
//Model also contains error transistions to simulate possible 
//signals errors (such as a bit change caused by cosmic interferance).
ctmc 
module producer 

valid: [0..1] init 0; 

[] (rdy = 0) & (valid = 1) -> .1:(valid' = 0); 

[] (rdy = 0) & (valid = 0) -> .1:(valid' = 1); 

[Faultvalid1] (valid = 1) -> .000000000001:(valid' = 0); 

[Faultvalid2] (valid = 0) -> .000000000001:(valid' = 1);

endmodule 


module consumer 

done: [0..1] init 0; 

[] (ack = 1) & (done = 0) -> .1:(done' = 1); 

[] (ack = 0) & (done = 1) -> .1:(done' = 0);

[Faultdone1] (done = 1) -> .000000000001:(done' = 0);

[Faultdone2] (done = 0) -> .000000000001:(done' = 1);

endmodule 


module sender 

rdy: [0..1] init 0; 

[] (valid = 1) & (ack = 0) & (rdy = 0) -> 1:(rdy' = 1); 

[] (rdy = 1) & (ack = 1) -> 1:(rdy' = 0);

[Faultrdy1] (rdy = 1) -> .000000000001:(rdy' = 0);

[Faultrdy2] (rdy = 0) -> .000000000001:(rdy' = 1);

endmodule 


module reciever 

ack: [0..1] init 0; 

[] (rdy = 1) & (ack = 0) & (done = 0) -> 1:(ack' = 1); 

[] (rdy = 0) & (done = 1) & (ack = 1) -> 1:(ack' = 0); 

[Faultack1] (ack = 1) -> .000000000001:(ack' = 0);

[Faultack2] (ack = 0) -> .000000000001:(ack' = 1);


endmodule 

rewards
	[Fault] true:1;
endrewards
