function [output,state] = tfm(A)

beta = 1/16;
state = 0;

L = length(A);
output(1) = A(1);
for idx=2:L
    state(idx) = max(0,min(127,round(state(idx-1)*(1-beta)) + round(127*A(idx)*beta)));
    output(idx) = rand(1,1) < state(idx);
end

