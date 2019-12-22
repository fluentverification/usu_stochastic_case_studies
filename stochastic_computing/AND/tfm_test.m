T     = 5000;  % Duration of path trace
N     = 100;   % Number of paths in ensemble
W     = 5000;  % Low index of window
estep = 0.01;  % Input probability step
econf = 10;    % State tolerance window (plus/minus econf)

pe = estep:estep:(1-estep);
%mu = zeros(1,numel(pe));

for edx = 1:numel(pe)
    p = pe(edx);
    
    prop_count = 0;
    for ndx = 1:N
        A = rand(T,1) < p;
        [output, state] = tfm(A);
        %mu(edx) = mean(state(W:T))/127;
        
        prop = (state(W:T) < p*127+econf) & (state(W:T) > p*127-econf);
        if (prod(prop)==1)
            prop_count = prop_count + 1;
        end
    end
    pg(edx) = prop_count/N;
end

% figure(2)
% plot(pe,pe,':',pe,mu)
% axis([0 1 0 1])

figure(3)
plot(pe,pg)
axis([0 1 0 1])