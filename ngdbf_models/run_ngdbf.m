% Wrapper for NGDBF Prism Models
clear;clc;
% Ask for inputs
fprintf("Default Values\n");
fprintf("Code Rate = 0.8413\n");
fprintf("SNR = 4.5\n");
fprintf("Threshold = -0.55\n");
fprintf("Weight = 1/6 (%f) \n",1/6);
fprintf("Transient probability calculation with 600 iterations ( -tr 600 ) \n");
check = input("Would you like to use the default values [y/n]? ","s");
if isempty(check)
    check = 'y';
end
code_rate = [];
SNR = [];
theta = [];
w = [];
tag = [];
if check ~= 'y'
    fprintf("Press enter to use default value\n");
    code_rate = input("Enter a new code rate: ");
    SNR = input("Enter a new SNR: ");
    theta = input("Enter a new threshold: ");
    w = input("Enter a new weight: ");
    tag = input("Enter a new simulation tag or property (ie -tr 500, -ss, -prop <property>, etc...): ",'s');
end
base_constants = "-const ";
if isempty(code_rate)
    code_rate=0.8413;
end
if isempty(SNR)
    SNR = 4.5;
end   
if isempty(theta)
    theta = -0.55;
end
if isempty(w)
    w = 1/6;
end
if isempty(tag)
    tag = "-tr 600";
end

file_out = fopen("output.txt","w");
% Set number of times to run
%rounds = input("Enter number of times to simulate: ");
%rounds = round(rounds);
E = 8; % Test every error combination
result = zeros(1,E);
%initialize input history
y1 = zeros(1,E);
y2 = zeros(1,E);
y3 = zeros(1,E);

% Run simulations
for n = 1:E
    % The y values are gaussian with mean +1 and variance N0/2
    % magnitude is taken so that error position can be determined
    sigma = sqrt(1/code_rate)*10^(-SNR/20);
    y1(n) = abs(normrnd(1,sigma));
    y2(n) = abs(normrnd(1,sigma));
    y3(n) = abs(normrnd(1,sigma));

    %Determine error position
    bin_n = dec2bin(n-1,3);
    if bin_n(1) == '1'
        y1(n) = -y1(n);
    end
    if bin_n(2) == '1' 
        y2(n) = -y2(n);
    end
    if bin_n(3) == '1' 
        y3(n) = -y3(n);
    end

    % Set initial node values
    x1 = sign(y1(n));
    x2 = sign(y2(n));
    x3 = sign(y3(n));
    
    % Create state matrix
    % States taken from Tasnuva dissertation (Table 3.1, pg 27)
    % state 1:  1  1  1 | 0 0 0 
    % state 2:  1  1 -1 | 0 0 1
    % state 3:  1 -1  1 | 0 1 0
    % state 4:  1 -1 -1 | 0 1 1
    % state 5: -1  1  1 | 1 0 0 
    % state 6: -1  1 -1 | 1 0 1
    % state 7: -1 -1  1 | 1 1 0
    % state 8: -1 -1 -1 | 1 1 1
    x = [
        1 1 1;
        1 1 -1;
        1 -1 1;
        1 -1 -1;
        -1 1 1;
        -1 1 -1;
        -1 -1 1;
        -1 -1 -1];

    %initialize Energy matrix
    E = zeros(8,3);
    % Calculate all possible energy values for each state
    for j = 1:8
        s1 = x(j,2)*x(j,3);
        s2 = x(j,1)*x(j,3);
        s3 = x(j,1)*x(j,3);
        s4 = x(j,1);
        s5 = x(j,2);
        s6 = x(j,3);
        E(j,1) = y1(n)*x(j,1) + w*(s3+s2+s4);
        E(j,2) = y2(n)*x(j,2) + w*(s3+s1+s5);
        E(j,3) = y3(n)*x(j,3)+w*(s1+s2+s6);
    end

    %% calculate transition probabilities
    p = zeros(8,8);
    % Flip probabilities calculated according to Eq 3.13 in Tasnuva
    % dissertation (pg. 26)
    row = 1;
    % State 1 (1 1 1)
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,1) = (1-px1)*(1-px2)*(1-px3);
    p(row,2) = (1-px1)*(1-px2)*px3;
    p(row,3) = (1-px1)*px2*(1-px3);
    p(row,4) = (1-px1)*px2*px3;
    p(row,5) = px1*(1-px2)*(1-px3);
    p(row,6) = px1*(1-px2)*px3;
    p(row,7) = px1*px2*(1-px3);
    p(row,8) = px1*px2*px3;

    % State 2 (1 1 -1)
    row = 2;
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,2) = (1-px1)*(1-px2)*(1-px3);
    p(row,1) = (1-px1)*(1-px2)*px3;
    p(row,4) = (1-px1)*px2*(1-px3);
    p(row,3) = (1-px1)*px2*px3;
    p(row,6) = px1*(1-px2)*(1-px3);
    p(row,5) = px1*(1-px2)*px3;
    p(row,8) = px1*px2*(1-px3);
    p(row,7) = px1*px2*px3;

    % State 3 ( 1 -1 1)
    row = 3;
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,3) = (1-px1)*(1-px2)*(1-px3); % ( 1 -1 1) 
    p(row,4) = (1-px1)*(1-px2)*px3; % (1 -1 -1) 
    p(row,1) = (1-px1)*px2*(1-px3); % (1 1 1) 
    p(row,2) = (1-px1)*px2*px3; %(1 1 -1) 
    p(row,7) = px1*(1-px2)*(1-px3); %(-1 -1 1) 
    p(row,8) = px1*(1-px2)*px3; %(-1 -1 -1) 
    p(row,5) = px1*px2*(1-px3); %(-1 1 1)
    p(row,6) = px1*px2*px3;

    % State 4 (1 -1 -1)
    row = 4;
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,4) = (1-px1)*(1-px2)*(1-px3);
    p(row,3) = (1-px1)*(1-px2)*px3; % (1 -1 1)
    p(row,2) = (1-px1)*px2*(1-px3); % (1 1 -1)
    p(row,1) = (1-px1)*px2*px3; % (1 1 1)
    p(row,8) = px1*(1-px2)*(1-px3); % (-1 -1 -1)
    p(row,7) = px1*(1-px2)*px3; % (-1 -1 1)
    p(row,6) = px1*px2*(1-px3); % (-1 1 -1
    p(row,5) = px1*px2*px3;

    % State 5 (-1 1 1)
    row = 5;
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,5) = (1-px1)*(1-px2)*(1-px3);
    p(row,6) = (1-px1)*(1-px2)*px3; % (-1 1 -1)
    p(row,7) = (1-px1)*px2*(1-px3); % (-1 -1 1)
    p(row,8) = (1-px1)*px2*px3; % (-1 -1 -1)
    p(row,1) = px1*(1-px2)*(1-px3); % (1 1 1)
    p(row,2) = px1*(1-px2)*px3; % (1 1 -1)
    p(row,3) = px1*px2*(1-px3); % (1 -1 1)
    p(row,4) = px1*px2*px3;

    % State 6 (-1 1 -1)
    row = 6;
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,6) = (1-px1)*(1-px2)*(1-px3);
    p(row,5) = (1-px1)*(1-px2)*px3; % (-1 1 1)
    p(row,8) = (1-px1)*px2*(1-px3); % (-1 -1 -1)
    p(row,7) = (1-px1)*px2*px3; % (-1 -1 1)
    p(row,2) = px1*(1-px2)*(1-px3); % (1 1 -1)
    p(row,1) = px1*(1-px2)*px3;
    p(row,4) = px1*px2*(1-px3); %(1 -1 -1)
    p(row,3) = px1*px2*px3;

    % State 7 (-1 -1 1)
    row = 7;
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,7) = (1-px1)*(1-px2)*(1-px3);
    p(row,8) = (1-px1)*(1-px2)*px3;
    p(row,5) = (1-px1)*px2*(1-px3); % (-1 1 1)
    p(row,6) = (1-px1)*px2*px3;
    p(row,3) = px1*(1-px2)*(1-px3);
    p(row,4) = px1*(1-px2)*px3;
    p(row,1) = px1*px2*(1-px3);
    p(row,2) = px1*px2*px3;

    % State 8 (-1 -1 -1)
    row = 8;
    px1 = normcdf(theta,E(row,1),sigma);
    px2 = normcdf(theta,E(row,2),sigma);
    px3 = normcdf(theta,E(row,3),sigma);
    p(row,8) = (1-px1)*(1-px2)*(1-px3);
    p(row,7) = (1-px1)*(1-px2)*px3;
    p(row,6) = (1-px1)*px2*(1-px3); % (-1 1 -1)
    p(row,5) = (1-px1)*px2*px3;
    p(row,4) = px1*(1-px2)*(1-px3);
    p(row,3) = px1*(1-px2)*px3;
    p(row,2) = px1*px2*(1-px3);
    p(row,1) = px1*px2*px3;
    
    if sum(round(sum(p.'))) ~= 8
        fprintf("Error: Probabilities do not sum to 1\n");
        exit();
    end

    %% Write File
    % constants = base_constants+"y1="+y1(n)+",y2="+y2(n)+",y3="+y3(n);
    
    % Select NGDBF Model
    % Only the dtmc binary model is complete
     model_path = "binary/dtmc_ngdbf_3bit.prism";
     prop_path = "binary/halt_dtmc.pctl";
     [stat, istate] = write_model(model_path,y1(n),y2(n),y3(n),p);
    % Simulate Model and Capture Output
     [status,output] = system("prism "+ model_path +" "+tag);
      if status == 1
         fprintf("%s\n",output);
         return;
     else
        %% Process output
        % extract result probability
%         temp1 = regexp(output,"Result: ",'split'); 
%         temp2 = split(temp1(2),' ');
%         result(n) = str2double(temp2(1));
        if y1(n) > 0
            x1 = 0;
        else
            x1 = 1;
        end
        if y2(n) > 0
            x2 = 0;
        else
            x2 = 1;
        end
        if y3(n) > 0
            x3 = 0;
        else
            x3 = 1;
        end

        fprintf(file_out,"%s\n\n%d:\tResult: N/A with samples %e (%d),%e (%d),%e (%d) \t initial state: %d\n-------------------------\n",output,n,y1(n),x1,y2(n),x2,y3(n),x3,istate);
      end

end
fclose(file_out);