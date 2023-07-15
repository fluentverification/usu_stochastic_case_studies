function name = write_explicit_model(trans_mat,init_state,finish_condition)
    % Set up folder variables
    [length,~] = size(trans_mat);
    binary_size = floor(log2(length));
    init_state_str = dec2bin(init_state,binary_size);
    base_folder_name = "explicit_model_";
    folder_name = strcat("models/",base_folder_name,init_state_str);
    % create folder
    [~,~] = mkdir(folder_name);

    % Set up file name variables
    base_file_name = strcat(folder_name,"/ngdbf",init_state_str);
    state_name = strcat(base_file_name,".sta");
    label_name = strcat(base_file_name,".lab");
    trans_name = strcat(base_file_name,".tra");
    % Return name with a leading space
    % strcat strips tailing whitespace but not leading whitespace
    name_temp = strcat("|",base_file_name);
    name_temp(1) = " ";
    name = name_temp;

    % Open/Create files
    fid_state = fopen(state_name,"w");
    fid_label = fopen(label_name,"w");
    fid_trans = fopen(trans_name,"w");
    
    % Write state file
    fprintf(fid_state, "(state)\n");
    for idx = 0:(length-1)
        fprintf(fid_state,"%d:(%d)\n",idx,idx);
    end
    fclose(fid_state);

    % Write label file
    fprintf(fid_label,'0="init" 1="deadlock" 2="finish"');
    for idx = 0:(length-1)
        fprintf(fid_label,'%d="state_%d" ',idx+2,idx);
    end
    fprintf(fid_label,"\n");
    for idx = 0:(length-1)
        if idx == 0 
            if init_state == 0
                fprintf(fid_label,"%d: 0 2\n",idx);
            else
                fprintf(fid_label,"%d: 2\n",idx);
            end
        elseif idx == init_state
            fprintf(fid_label,"%d: 0 %d\n",idx, idx+2);
        else
            fprintf(fid_label,"%d: %d\n",idx,idx+2);
        end
    end
    fclose(fid_label);

    % Write trans file
    if finish_condition
        num_edges = (length*length)-length+1;
    else
        num_edges = length*length;
    end
    fprintf(fid_trans, "%d %d\n",length,num_edges);
    for x = 1:length
        for y = 1:length
            if finish_condition && x ==1 && y==1
                fprintf(fid_trans,"0 0 1\n");
            elseif finish_condition && x==1 && y~=1
                % Do Nothing
                %fprintf(fid_trans,"%d %d %e\n",x-1,y-1,trans_mat(x,y));
            else
                fprintf(fid_trans,"%d %d %e\n",x-1,y-1,trans_mat(x,y));
            end
    
        end
    end
    fclose(fid_trans);

end