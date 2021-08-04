warning('off', 'all');

d=importdata('outfile',' ');
s = sum(d.data(:,3:12)') + 2*d.data(:,13)';
zdx = find(s==0);
Nfail = 0;
Npath  = 0;
for l=1:length(zdx)-1
    if (find(s(zdx(l):zdx(l+1))>1))
       Nfail  =  Nfail + 1;
    end
    Npath = Npath + 1;
end

pfail = Nfail/Npath;

fprintf(1,"Failure Probability \t lambda = %f\n", pfail);

t = d.data(:,2);
idx=find(s==0);
idx = idx(1:end-1);
jdx = idx+1;
kdx = idx(2:end);

t0 = mean(t(kdx)-t(jdx(1:end-1)));

fprintf(1,"Return time \t\t tau_0  = %f\n", t0)
fprintf(1,"\t\t\t MTTF   = %f\n", t0/pfail)
