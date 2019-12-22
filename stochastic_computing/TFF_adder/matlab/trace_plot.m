[trace,delim] = importdata('trace.txt', ' ', 2);

N = 7;

d = trace.data;

t = d(:,1);
A = d(:,2);
B = d(:,3);
C = d(:,4);
Q = d(:,5);
T = d(:,6);
W = d(:,7);
Z = d(:,8);
X = mod(A+B,2);
tdx = find(X==1);
bdx = find(X==0);
Zexp = B;
Zexp(tdx) = Q(tdx);
Qexp = mod(cumsum(C.*X),2);

figure(1)
clf

plabels = {{'A'},{'B'},{'clock'},{'Q'},{'T'},{'W'},{'Z'}};

for idx=1:7
   subplot(N,1,idx)
   if (idx==5)
       stairs(t,d(:,idx+1),'b','LineWidth',1.5)
       hold on
       stairs(t,X,'r')
       hold off
   elseif (idx==4)
       stairs(t,d(:,idx+1),'b','LineWidth',1.5)
       hold on
       stairs(t,Qexp,'r')
       hold off  
   elseif (idx==7)
       stairs(t,d(:,idx+1),'b','LineWidth',1.5)
       hold on
       stairs(t,Zexp,'r')
       hold off       
   else
       stairs(t,d(:,idx+1),'b','LineWidth',1.5)
   end
   axis([min(t) max(t) -0.2 1.2])
   set(gca,'YTickLabel',[]);
   set(gca,'XTickLabel',[]);
   ylabel(plabels{idx})
   hold on
   for jdx=1:2:100
       ha=area([jdx jdx+1], [1.2 1.2], 'FaceColor','blue','FaceAlpha',0.1,'LineStyle','none');
       %ha.FaceColor = [0 0 0.25];
   end
   hold off
end

xlabel('Time Steps')

