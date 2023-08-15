% Wrapper for NGDBF Prism Models
function p_out = run_ngdbf_storm(adj_mat,explicit_model,finish_condition)
    %fid_test = fopen("idx_debug.txt","w");
    if isOctave()
        pkg load statistics;
    end
    if nargin < 1
        print_help();
        return;
    elseif nargin == 1
        if isscalar(adj_mat)
            print_help();
            return;
        else
            explicit_model = false;
            finish_condition = true;
        end
    elseif nargin > 1 && ~islogical(explicit_model) 
        print_help();
        return;
    elseif nargin >2 && ~islogical(finish_condition)
        print_help();
        return;
    end


    clc;
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
        tag = input("Enter a new simulation tag or property (ie -tr 500, -ss, -prop <property>, etc...) Must have a leading space: ",'s');
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
        tag = ' "P=? [ true U[0,600] (state=0) ]"';
    end
    
    file_out = fopen("output.txt","w"); % Open output file
    %sym_size = width(adj_mat); % Number of variable nodes
    %check_size = length(adj_mat); % Number of check nodes
    [check_size,sym_size] = size(adj_mat); %Number of variable and check nodes
    error_total = 2^sym_size; % Number of possible errors
    sigma = sqrt(1/code_rate)*10^(-SNR/20);
    p_out = zeros(2^sym_size,2^sym_size); % initialize results 

    time_sample_begin = time();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%% Generate sample values %%%%%%%%%%%%%%%%%%%%
    loop_check = get_error_sample_size(sym_size);
    valid_samples = zeros(1,loop_check);
    valid_idx = 1;
    error_samples = zeros(1,loop_check);
    error_idx = 1;
    while valid_idx <= loop_check || error_idx <= loop_check
        temp = normrnd(1,sigma);
        if temp > 0
            valid_samples(valid_idx) = temp;
            valid_idx = valid_idx +1;
        end
        if temp < 0
            error_samples(error_idx) = temp;
            error_idx = error_idx+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    time_sample_end = time();
    fprintf("sample generation took %d seconds\n",time_sample_end-time_sample_begin);

    % Run simulations
    for idx = 1:error_total
        %%%%%%%%%%%%%%%%%%%%%%%% Choose error values %%%%%%%%%%%%%%%%%%%%%%
        bin_pos = dec2bin(idx-1,sym_size);
        y = zeros(1,sym_size); %initialize inputs
        for n = 1:sym_size
            if bin_pos(n) == '1'
                error_idx = error_idx-1;
                % TODO: Research Gaussian tail distributions to effectively generate error samples
                % Temporary solution applied
                y(n) = error_samples(error_idx); 
            else
                valid_idx = valid_idx-1;
                y(n) = valid_samples(valid_idx);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        % Calculate Energies
        begin = time();
        E = calculate_energies(adj_mat,y,w,sym_size,check_size);
        E_end = time();
        fprintf("Energy calculation took %d seconds\n",E_end-begin);
        % Calculate Probabilities
        begin = time();
        p = calculate_probabilities(E,theta,sigma,sym_size);
        p_end = time();
        fprintf("probability calculation took %d seconds\n",p_end-begin);

        %%%%%%%%%%%%%%%%%%%%%% Write File %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        begin = time();
        if ~explicit_model
            % Regular Model
            model_path =strcat(' models/ngdbf_trapping_',num2str(sym_size),'symbol_',bin_pos,'.prism');
            [stat, istate] = write_model(substr(model_path,2),y,p,finish_condition);
            % Simulate Model and Capture Output
            [status,output] = system(strcat("storm --prism ", model_path ," --prop ",tag));
        else
            % Explicit Model
            istate = idx-1;
            model_path = write_explicit_model(p,istate,finish_condition);
            [status,output] = system(strcat("prism -importmodel ",model_path,".all ",tag, " -dtmc"));
            
        end
        file_end = time();
        fprintf("File writing and simulation took %d seconds\n",file_end-begin);
        begin = time();
        if status == 1 
            fprintf("%s\n",output);
            return;
        else
            % Process Output for transient and steady state
            if (tag(3) == 't' && tag(4) == 'r') || (tag(3) == 's' && tag(4) == 's')
                str_idx = regexp(output,regexptranslate('wildcard','0:\(*\)=*'));
                %fprintf(fid_test,"str_idx: %d\n",str_idx);
                output = substr(output,str_idx);
                split_output = strsplit(output,"\n"); 
                for out_idx = 1:2^sym_size
                    str_to_parse = char(split_output(out_idx));
                    
                    if (str_to_parse(1) >= "0") && (str_to_parse(1) <= "9")
                        temp = textscan(str_to_parse,"%d:(%d)=%f");
                        state_temp = temp{1,2};
                        p_out(idx,state_temp+1) = temp{1,3};
                    else
                        break; 
                    end
                end
            elseif tag(3) == 'P'
                str_idx = strfind(output,"Result");
                output = substr(output,str_idx);
                p_temp = textscan(output,"Result (for initial states): %f");
                p_out(idx,1) = p_temp{1,1};
            else
                % Do nothing
            end
           fprintf(file_out,"initial state: %d\n%s\n----------------------------------------------------------------------------------------------------\n\n",istate,output);
         end
         process_end = time();
         fprintf("output processing took %d seconds\n\n\n",process_end-begin);
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    fprintf("\n\nThe matrix outputted contains the probabilities that the models ends in a certain state for each error configuration.\n ");
    fprintf("For example, to find the probability that the model ends in the all-zero state with error configuration 7 you would look at p_out(8,1)\n\n");
    fclose(file_out);
    %fclose(fid_test);
end
