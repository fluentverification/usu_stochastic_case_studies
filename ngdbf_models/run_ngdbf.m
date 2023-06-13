% Wrapper for NGDBF Prism Models
function [p,y] = run_ngdbf(trans_mat)
    clc;
    if width(trans_mat) ~= length(trans_mat)
        fprintf("Error: Dimensions of transition matrix do not match\n");
        return
    end
   
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
    
    file_out = fopen("output.txt","w"); % Open output file
    var_size = length(trans_mat); % Number of variable nodes
    check_size = sum(sum(trans_mat))-var_size; % Number of check nodes
    error_total = 2^var_size; % Number of possible errors
    y = zeros(1,var_size); %initialize inputs
    
    % Run simulations
    for idx = 1:error_total
        sigma = sqrt(1/code_rate)*10^(-SNR/20);
        bin_pos = dec2bin(idx-1,var_size);
        x_sign = zeros(1,var_size);
        %Produce y values
        for n = 1:var_size
            % The y values are gaussian with mean +1 and variance N0/2
            % magnitude is taken so that error position can be determined
            y(n) = abs(normrnd(1,sigma));
            %Determine error position
            if bin_pos(n) == '1'
                y(n) = -y(n);
            end
            % Set initial node values
            x_sign(n) = sign(y(n));
        end
    
        % Create state matrix
        % States taken from Tasnuva dissertation (Table 3.1, pg 27)
        x_str = [dec2bin(0:(2^var_size)-1,var_size)];
        x = zeros(2^var_size,var_size);
        % convert to bipolar states
        for row = 1:2^var_size
            for col = 1:var_size
                  x(row,col) = str2num(x_str(row,col));
                if x(row,col) == 1
                    x(row,col) = -1;
                else
                    x(row,col) = 1;
                end
            end
        end
        %x = int(x);
    
        %initialize Energy and check node matrices
        E = zeros(2^var_size,var_size);
        s = zeros(1, check_size);
        s_sum = zeros(1,var_size);
        % Calculate all possible energy values for each state
        for row = 1:2^var_size
            % Calculate all check nodes
            s_idx = 1;
            for tran_row = 1:length(trans_mat)
                for tran_col = 1:tran_row
                    if trans_mat(tran_row,tran_col) == 1
                        if tran_row == tran_col
                            s(s_idx) = x(row,tran_row);
                            s_sum(tran_row) = s_sum(tran_row)+s(s_idx);
                        else
                            s(s_idx) = x(row,tran_row)*x(row,tran_col);
                            s_sum(tran_row) = s_sum(tran_row)+s(s_idx);
                            s_sum(tran_col) = s_sum(tran_col)+s(s_idx);
                        end
                        s_idx = s_idx+1;
                    end
                end
            end
            % Calculate energy values
            for E_idx = 1:var_size
                E(row,E_idx) = y(E_idx)*x(row,E_idx)+w*s_sum(E_idx);
            end
        end
    
        %% calculate transition probabilities
        p = ones(2^var_size,2^var_size);
        % Flip probabilities calculated according to Eq 3.13 in Tasnuva
        % dissertation (pg. 26)
        for row = 1:2^var_size
            px = zeros(1,var_size);
            for p_idx = 1:var_size
                px(p_idx) = normcdf(theta,E(row,p_idx),sigma);
            end
            rowbin = dec2bin(row-1,var_size);
            for col = 1:2^var_size
                colbin = dec2bin(col-1,var_size);
                for p_idx = 1:var_size
                    if rowbin(p_idx) == colbin(p_idx)
                        p(row,col) = p(row,col)*(1-px(p_idx));
                    else
                        p(row,col) = p(row,col)*px(p_idx);
                    end
                end
            end
        end
        
        if sum(round(sum(p.'))) ~= 2^var_size
            fprintf("Error: Probabilities do not sum to 1\n");
            return;
        end
    
        %% Write File
        % constants = base_constants+"y1="+y1(n)+",y2="+y2(n)+",y3="+y3(n);
        
        % Select NGDBF Model
        % Only the dtmc binary model is complete
         model_path = "binary/dtmc_ngdbf_3bit.prism";
        % prop_path = "binary/halt_dtmc.pctl";
         [stat, istate] = write_model(model_path,y,p);
        % Simulate Model and Capture Output
         [status,output] = system("prism "+ model_path +" "+tag);
          if status == 1 || stat == 1
             fprintf("%s\n",output);
             return;
         else
            %% Process output
            % extract result probability
    %         temp1 = regexp(output,"Result: ",'split'); 
    %         temp2 = split(temp1(2),' ');
    %         result(n) = str2double(temp2(1));
            
     
            fprintf(file_out,"%s\ninitial state: %d\n----------------------------------------------------------------------------------------------------\n\n",output,istate);
          end
    
    end
    fclose(file_out);
end