clear;
format long;
%Select the file to edit
fid = -1;
errmsg = '';
while fid < 0 
   disp(errmsg);
   filename = input('Open file: ', 's');
   [fid,errmsg] = fopen(filename,'a');
end

%Create 6-sigma array
x = -6:(12/100):6;
%Create unit distribution and normalize
unit_dist = normcdf(x,0,1); 
pvec = zeros(1,101);
pvec(1) = unit_dist(1);
for n = 2:101
    pvec(n) = unit_dist(n)- unit_dist(n-1);
end
%Gather probability as n->inf
sig = 1;
mu = 0;
syms x;
pd = (1/(sig*sqrt(2*pi)))*exp(-0.5*((x-mu)/sig)^2);
pvec(101) = pvec(101)+int(pd,6,inf);

% Create integer array
y = -50:50;
fprintf(fid,"module gaussian_variable1 \n gauss_var1: [-50..50];\n [sync] !done -> ");
for n=1:100
     fprintf(fid,"%0.16f:(gauss_var1'=%d)+",pvec(n),y(n));
end
fprintf(fid,"%0.16f:(gauss_var1'=%d);",pvec(101),y(101));
fprintf(fid,"\n endmodule \n");
fprintf(fid,"module gaussian_variable2 = gaussian_variable1[ gauss_var1=gauss_var2 ] endmodule\n");
fprintf(fid,"module gaussian_variable3 = gaussian_variable1[ gauss_var1=gauss_var3 ] endmodule\n");
fclose(fid);