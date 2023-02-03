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
unit_dist = normpdf(x,0,1); %<-- This does not sum to 1
normalized_dist = unit_dist/sum(unit_dist); %<-- Does this change the distribution?

%Create integer array
y = -50:50;
fprintf(fid,"module gaussian_variable1 \n gauss_var1: [-50..50];\n [sync] !done -> ");
for n=1:101
     fprintf(fid,"%f:(gauss_var1'=%d)+",normalized_dist(n),y(n));
end
fprintf(fid,"\n endmodule \n");
fprintf(fid,"module gaussian_variable2 = gaussian_variable1[ gauss_var1=gauss_var2 ];\n");
fprintf(fid,"module gaussian_variable3 = gaussian_variable1[ gauss_var1=gauss_var3 ];\n");
fclose(fid);