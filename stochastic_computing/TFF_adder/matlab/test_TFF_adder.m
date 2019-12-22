T=10000;

pA = 0.1;
pB = 0.1;

for idx=1:8
    for jdx=1:8
        A = rand(1,T)<pA;
        B = rand(1,T)<pB;
        Z = TFF_adder(A,B);
        pout(idx,jdx) = mean(Z);
        pA = pA+0.1;
    end
    pA = 0.1;
    pB = pB + 0.1;
end

plot(pout')

