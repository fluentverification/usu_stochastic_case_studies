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
error_total = 8; % Test every error combination
var_size = 3; % Number of variable nodes
result = zeros(1,error_total);
%initialize input history
y = zeros(var_size,error_total);
% y2 = zeros(1,error_total);
% y3 = zeros(1,error_total);

% Run simulations
for idx = 1:error_total
    sigma = sqrt(1/code_rate)*10^(-SNR/20);
    bin_pos = dec2bin(idx-1,3);
    x_state = zeros(1,var_size);
%     y1(position) = abs(normrnd(1,sigma));
%     y2(position) = abs(normrnd(1,sigma));
%     y3(position) = abs(normrnd(1,sigma));
    for n = 1:var_size
        % The y values are gaussian with mean +1 and variance N0/2
        % magnitude is taken so that error position can be determined
        y(n,idx) = abs(normrnd(1,sigma));
        %Determine error position
        if bin_pos(n) == '1'
            y(n,idx) = -y(n,idx);
        end
        % Set initial node values
        x_state(n) = sign(y(n,idx));
    end

    
    
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
    x_state = [
        1 1 1;
        1 1 -1;
        1 -1 1;
        1 -1 -1;
        -1 1 1;
        -1 1 -1;
        -1 -1 1;
        -1 -1 -1];

    %initialize Energy matrix
    error_total = zeros(8,3);
    % Calculate all possible energy values for each state
    for row = 1:8
        s1 = x_state(row,2)*x_state(row,3);
        s2 = x_state(row,1)*x_state(row,3);
        s3 = x_state(row,1)*x_state(row,3);
        s4 = x_state(row,1);
        s5 = x_state(row,2);
        s6 = x_state(row,3);
        error_total(row,1) = y1(idx)*x_state(row,1) + w*(s3+s2+s4);
        error_total(row,2) = y2(idx)*x_state(row,2) + w*(s3+s1+s5);
        error_total(row,3) = y3(idx)*x_state(row,3)+w*(s1+s2+s6);
    end

    %% calculate transition probabilities
    p = zeros(8,8);
    % Flip probabilities calculated according to Eq 3.13 in Tasnuva
    % dissertation (pg. 26)
    for row = 1:8
        px1 = normcdf(theta,error_total(row,1),sigma);
        px2 = normcdf(theta,error_total(row,2),sigma);
        px3 = normcdf(theta,error_total(row,3),sigma);
        rowbin = dec2bin(row-1,3);
        for col = 1:8
            colbin = dec2bin(col-1,3);
            if rowbin(1) == colbin(1)
                p(row,col) = 1-px1;
            else
                p(row,col) = px1;
            end
            if rowbin(2) == colbin(2)
                p(row,col) = p(row,col)*(1-px2);
            else
                p(row,col) = p(row,col)*px2;
            end
            if rowbin(3) == colbin(3)
                p(row,col) = p(row,col)*(1-px3);
            else
                p(row,col) = p(row,col)*px3;
            end
        end
    end
    
    if sum(round(sum(p.'))) ~= 8
        fprintf("Error: Probabilities do not sum to 1\n");
        return;
    end

    %% Write File
    % constants = base_constants+"y1="+y1(n)+",y2="+y2(n)+",y3="+y3(n);
    
    % Select NGDBF Model
    % Only the dtmc binary model is complete
     model_path = "binary/dtmc_ngdbf_3bit.prism";
    % prop_path = "binary/halt_dtmc.pctl";
     [stat, istate] = write_model(model_path,y1(idx),y2(idx),y3(idx),p);
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
        if y1(idx) > 0
            x1 = 0;
        else
            x1 = 1;
        end
        if y2(idx) > 0
            x2 = 0;
        else
            x2 = 1;
        end
        if y3(idx) > 0
            x3 = 0;
        else
            x3 = 1;
        end

        fprintf(file_out,"%s\n\n%d:\tResult: N/A with samples %e (%d),%e (%d),%e (%d) \t initial state: %d\n-------------------------\n",output,idx,y1(idx),x1,y2(idx),x2,y3(idx),x3,istate);
      end

end
fclose(file_out);