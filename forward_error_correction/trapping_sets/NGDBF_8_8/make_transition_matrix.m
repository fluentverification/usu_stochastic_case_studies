trap8_8

SNR=3;
R=0.8413;
N0=10^(-SNR/10)/R;
sigma=sqrt(N0/2);
y=1+sigma*randn(8,1);
dv=6;
alpha=1;
w=0.16;
theta=-0.5;
tmat=tsreg(H, dv, y, sigma, alpha, w, theta);
[nr,nc]=size(tmat);

fid = fopen('trapping_set.tra','w');

fprintf(fid,'%d %d\n',nr, nc);
for r=1:nr
    for c=1:nc
        fprintf(fid,'%d %d %e\n',r, c, tmat(r,c));
    end
end
