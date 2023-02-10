clear;
syms x;
% parameters for unit normal distribution
sig = 1;
mu = 0;
pd = (1/(sig*sqrt(2*pi)))*exp(-0.5*((x-mu)/sig)^2);
%Set sigma range
sig_n = -6;
sig_p = 6;
%collect probability beyond sigma range
p1 = int(pd, -inf, sig_n);
p2 = int(pd, sig_p, inf);
%Compute discrete probabilities
n = -6:(abs(sig_n)+sig_p)/100:6;
pvec = zeros(1,101);
for idx = 2:101
    pvec(idx-1) = int(pd,n(idx-1),n(idx));
end
pvec(1) = p1+pvec(1);
pvec(101) = p2;