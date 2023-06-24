function [status,state] = write_model(fileName,y,p)
    y_size = length(y);
    x = zeros(1,y_size);
    state = 1;
    for idx = 1:y_size
        if y(idx) > 0
            x(idx) = 0;
        else
            x(idx) = 1;
        end
        state = state+(x(idx)*2^(idx-1));
    end
  
    fid = fopen(fileName,'w');
    fprintf(fid,"dtmc\n\n");
    % Print labels
    for i = 1:2^y_size
        label = i-1;
        fprintf(fid,'label "state_%d" = (state=%d);\n ',label,label);
    end

    % Write Module
    fprintf(fid,"module trapping_set \n");
    fprintf(fid,"\tstate : [0..%d] init %d;\n",(2^y_size)-1,state-1);
    %fprintf(fid,"\thalt : bool init false;\n\n");
    %fprintf(fid,"\t[finish] done -> 1:(halt' = true);\n");
    for i = 1:2^y_size
        if i ~= 1
            fprintf(fid,"\t[] state=%d -> ",i-1);
            for j=1:2^y_size
                fprintf(fid,"%.8f:(state'=%d)",p(i,j),j-1);
                if j ~= 2^y_size
                    fprintf(fid,"+");
                end
            end
        else
            %fprintf(fid,"\t[finish] state=%d -> 1: (halt' = true) ",i);
            fprintf(fid,"\t[] state=%d -> 1: (state' = 0) ",i-1);
        end
        
        fprintf(fid,";\n");
    end

    fprintf(fid,"endmodule\n");
    status = 0;
    fclose(fid);
    state = state-1;
end
