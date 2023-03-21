% Wrapper for NGDBF Prism Models
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
constants = "-consts ";
if ~isempty(code_rate)
    constants = constants+"r="+code_rate+",";
end
if ~isempty(SNR)
    constants = constants+"SNR="+SNR+",";
end

if ~isempty(th)
    constants=constants+"theta="+th+",";
end

if ~isempty(w)
    constants=constants+"w="+w+",";
end

%% Generate samples 
y1 = 0.4;
y2 = -1.2;
y3 = 0.6353;
constants = constants+y1+",y2="+y2+",y3="+y3;
%% Select NGDBF Model

%% Simulate Model and Capture input
path = "binary/dtmc_ngdbf_3bit.prism";
prop = "binary/halt_dtmc.pctl";
output = system("prism "+ path +" "+prop+" "+constants);

%% Process input

