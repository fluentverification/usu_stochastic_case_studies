% Wrapper for NGDBF Prism Models
clear;
%% Ask for inputs
fprintf("Default Values\n");
fprintf("Code Rate = 0.8413\n");
fprintf("SNR = 4.5\n");
fprintf("Threshold = -0.55\n");
fprintf("Weight = 1/6 (%f) \n",1/6);
check = input("Would you like to use the default values [y/n]? ","s");
if isempty(check)
    check = 'y';
end
code_rate = [];
SNR = [];
th = [];
w = [];
if check ~= 'y'
    fprintf("Press enter to use default value\n");
    code_rate = input("Enter a new code rate: ");
    SNR = input("Enter a new SNR: ");
    th = input("Enter a new threshold: ");
    w = input("Enter a new weight: ");
end
base_constants = "-const ";
if isempty(code_rate)
    code_rate=0.8413;
end
if isempty(SNR)
    SNR = 4.5;
end   
if isempty(th)
    th = -0.55;
end
if isempty(w)
    w = 1/6;
end
base_constants = base_constants+"w="+w+","+"theta="+th+","+"SNR="+SNR+","+"r="+code_rate+",";
iter = input("Enter number of iterations: ");
iter = round(iter);
result = zeros(1,iter);
y1 = zeros(1,iter);
y2 = zeros(1,iter);
y3 = zeros(1,iter);
for n = 1:iter
    %% Generate samples
    %TODO:actually generate samples
    % The y values are gaussian with mean +1 and variance N0/2
    sigma = sqrt(1/code_rate)*10^(-SNR/20);
    y1(n) = normrnd(1,sigma);
    y2(n) = normrnd(1,sigma);
    y3(n) = normrnd(1,sigma);
    
    constants = base_constants+"y1="+y1(n)+",y2="+y2(n)+",y3="+y3(n);
    
    %% Select NGDBF Model
    %Only the dtmc binary model is complete
    model_path = "binary/dtmc_ngdbf_3bit.prism";
    prop_path = "binary/halt_dtmc.pctl";
    
    %% Simulate Model and Capture Output
    [status,output] = system("prism "+ model_path +" "+prop_path+" "+constants);
    if status == 1
        fprintf("%s",output);
    else
    %% Process output
    %extract result probability
    temp1 = regexp(output,"Result: ",'split'); 
    temp2 = split(temp1(2),' ');
    result(n) = str2double(temp2(1));
    fprintf("%d:\tResult: %f with samples %f,%f,%f\n",n,result(n),y1(n),y2(n),y3(n));
    end
end