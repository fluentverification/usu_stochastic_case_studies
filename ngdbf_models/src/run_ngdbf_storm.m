% Driver for NGDBF Prism Models
function p_out = run_ngdbf_storm(adj_mat,sigma,theta,w,tag,explicit_model,finish_condition)
    explicit_model = false;
    finish_condition = true;

    file_out = fopen("output_storm.txt","w"); % Open output file
    [check_size,sym_size] = size(adj_mat); %Number of variable and check nodes
    error_total = 2^sym_size; % Number of possible errors
    
    p_out = zeros(2^sym_size,2^sym_size); % initialize results 

    % Generate Samples
    [valid_samples,error_samples,valid_idx,error_idx] = generate_samples(sym_size,sigma);

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
        % y = [-1.3, 0.2, -0.5];
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        % Calculate Energies
        E = calc_energies(adj_mat,y,w,sym_size,check_size);

        % Calculate Probabilities
        [p,status] = calc_prob(E,theta,sigma,sym_size);
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
    
        if status == 1 
            fprintf("%s\n",output);
            return;
        else
            str_idx = strfind(output,"Result");
            output = substr(output,str_idx);
            p_temp = textscan(output,"Result (for initial states): %f");
            p_out(idx,1) = p_temp{1,1};
            fprintf(file_out,"initial state: %d\n%s\n----------------------------------------------------------------------------------------------------\n\n",istate,output);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    fclose(file_out);
endfunction
