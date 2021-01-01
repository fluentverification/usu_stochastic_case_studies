ctmc 
module producer 

valid: [0..1] init 0; 

[] (rdy = 0) & (valid = 1) -> .1:(valid' = 0); 

[] (rdy = 0) & (valid = 0) -> .1:(valid' = 1); 

[Fault] (rdy = 1) & (valid = 1) -> .01:(valid' = 0); 

endmodule 


module consumer 

done: [0..1] init 0; 

[] (ack = 1) & (done = 0) -> .1:(done' = 1); 

[] (ack = 0) & (done = 1) -> .1:(done' = 0);

endmodule 


module sender 

rdy: [0..1] init 0; 

[] (valid = 1) & (ack = 0) & (rdy = 0) -> 1:(rdy' = 1); 

[] (rdy = 1) & (ack = 1) -> 1:(rdy' = 0);

endmodule 


module reciever 

ack: [0..1] init 0; 

[] (rdy = 1) & (ack = 0) & (done = 0) -> 1:(ack' = 1); 

[] (rdy = 0) & (done = 1) & (ack = 1) -> 1:(ack' = 0); 

endmodule 

rewards
	[Fault] true:1;
endrewards
