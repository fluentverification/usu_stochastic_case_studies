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
limit = 4;
range = 2*limit;
%Create 6-sigma array
x = -6:(12/range):6;
%Create unit distribution and normalize
unit_dist = normcdf(x,0,1); 
pvec = zeros(1,range+1);
pvec(1) = unit_dist(1);
for n = 2:(range+1)
    pvec(n) = unit_dist(n)- unit_dist(n-1);
end
%Gather probability as n->inf
sig = 1;
mu = 0;
syms x;
pd = (1/(sig*sqrt(2*pi)))*exp(-0.5*((x-mu)/sig)^2);
pvec(range+1) = pvec(range+1)+int(pd,6,inf);

% Create integer array
y = -limit:limit;
fprintf(fid,"module gaussian_variable1 \n gauss_var1: [-%d..%d];\n [sync] !done -> ",limit,limit);
for n=1:range
     fprintf(fid,"%0.16f:(gauss_var1'=%d)+",pvec(n),y(n));
end
fprintf(fid,"%0.16f:(gauss_var1'=%d);",pvec(range+1),y(range+1));
fprintf(fid,"\n endmodule \n");
fprintf(fid,"module gaussian_variable2 = gaussian_variable1[ gauss_var1=gauss_var2 ] endmodule\n");
fprintf(fid,"module gaussian_variable3 = gaussian_variable1[ gauss_var1=gauss_var3 ] endmodule\n");
fclose(fid);