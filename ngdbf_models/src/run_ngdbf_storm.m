% Driver for NGDBF Prism Models
function p_out = run_ngdbf_storm(adj_mat,code_rate,SNR,theta,w,tag,explicit_model,finish_condition)
    %fid_test = fopen("idx_debug.txt","w");
    script_begin = time();
    if isOctave()
        pkg load statistics;
    end
    if nargin < 1
        print_help();
        return;
    elseif nargin == 8
        if isscalar(adj_mat)
            print_help();
            return;
        else
            explicit_model = false;
            finish_condition = true;
        end
    elseif nargin > 8 && ~islogical(explicit_model) 
        print_help();
        return;
    elseif nargin >9 && ~islogical(finish_condition)
        print_help();
        return;
    end
    
    file_out = fopen("output_storm.txt","w"); % Open output file
    [check_size,sym_size] = size(adj_mat); %Number of variable and check nodes
    error_total = 2^sym_size; % Number of possible errors
    sigma = sqrt(1/code_rate)*10^(-SNR/20);
    p_out = zeros(2^sym_size,2^sym_size); % initialize results 

    time_sample_begin = time();
    [valid_samples,error_samples,valid_idx,error_idx] = generate_samples(sym_size,sigma);
    time_sample_end = time();
    fprintf("sample generation took %d seconds\n",time_sample_end-time_sample_begin);

    % Run simulations
    for idx = 1:error_total
        loop_begin = time();
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
        E = calculate_energies(adj_mat,y,w,sym_size,check_size);
        
        % Calculate Probabilities
        [p,status] = calculate_probabilities(E,theta,sigma,sym_size);
        if status == -1
            return
        end

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
         fprintf("output processing took %d seconds\n",process_end-begin);
         fprintf("Loop took %d seconds\n\n\n",process_end-loop_begin);
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    fprintf("\n\nThe matrix outputted contains the probabilities that the models ends in a certain state for each error configuration.\n ");
    fprintf("For example, to find the probability that the model ends in the all-zero state with error configuration 7 you would look at p_out(8,1)\n\n");
    fclose(file_out);
    script_end = time();
    fprintf("Total run-time is %d seconds\n",script_end-script_begin);
endfunction
