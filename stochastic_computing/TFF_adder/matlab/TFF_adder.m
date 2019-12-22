function output = TFF_adder(A, B)

X = mod(A+B,2);

idx1 = find(X==1);
idx0 = find(X==0);

T=mod(cumsum(X),2);

output = zeros(1,numel(A));
output(idx1) = T(idx1);
output(idx0) = B(idx0);


    