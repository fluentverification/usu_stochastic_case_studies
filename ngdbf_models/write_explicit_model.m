function name = write_explicit_model(trans_mat,init_state)
    % Set up folder variables
    [length,~] = size(trans_mat);
    binary_size = floor(log2(length));
    init_state_str = dec2bin(init_state,binary_size);
    base_folder_name = "explicit_model_";
    folder_name = strjoin(["models/",base_folder_name,init_state_str],"");
    %command = strjoin(["mkdir",folder_name]," ");
    % create folder
    [~,~] = mkdir(folder_name);

    % Set up file name variables
    base_file_name = strjoin([folder_name,"/ngdbf",init_state_str],"");
    name = base_file_name;
    state_name = strjoin([base_file_name,".sta"],'');
    label_name = strjoin([base_file_name,".lab"],'');
    trans_name = strjoin([base_file_name,".tra"],'');

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
    fprintf(fid_trans, "%d %d\n",length,length*length);
    for x = 1:length
        for y = 1:length
            fprintf(fid_trans,"%d %d %e\n",x-1,y-1,trans_mat(x,y));
        end
    end
    fclose(fid_trans);

end