function [status,state] = write_model(fileName,y,p,finish_condition)
    y_size = length(y);
    x = zeros(1,y_size);
    state = 1;
    for idx = y_size:-1:1
        if y(idx) > 0
            x(idx) = 0;
        else
            x(idx) = 1;
        end
        pos = y_size-idx;
        state = state+(x(idx)*2^pos);
    end

    fid = fopen(fileName,'w');
    if fid == -1
        error("File: %s not found",fileName);
    end
    fprintf(fid,"dtmc\n\n");
    % Print labels
    fprintf(fid,'label "finish"=(state=0);\n')
    % for i = 1:2^y_size
    %     label = i-1;
    %     if i==1
    %         fprintf(fid,'label "finish"= (state=%d);\n ',label);
    %     else
    %         fprintf(fid,'label "state_%d"= (state=%d);\n ',label,label);
    %     end
    % end

    % Write Module
    fprintf(fid,"module trapping_set \n");
    fprintf(fid,"\tstate : [0..%d] init %d;\n",(2^y_size)-1,state-1);
    for i = 1:2^y_size
        if i ~= 1
            fprintf(fid,"\t[] state=%d -> ",(i-1));
            for j=1:2^y_size
                fprintf(fid,"%e:(state'=%d)",p(i,j),(j-1));
                if j ~= 2^y_size
                    fprintf(fid,"+");
                end
            end
        else
            %fprintf(fid,"\t[finish] state=%d -> 1: (halt' = true) ",i);
            if finish_condition
                fprintf(fid,"\t[] state=%d -> 1: (state' = 0) ",(i-1));
            else
                fprintf(fid,"\t[] state=%d -> ",(i-1));
                for j=1:2^y_size
                    fprintf(fid,"%e:(state'=%d)",p(i,j),(j-1));
                    if j ~= 2^y_size
                        fprintf(fid,"+");
                    end
                end
            end
        end
        fprintf(fid,";\n");
    end
    fprintf(fid,"endmodule\n");
    status = 0;
    fclose(fid);
    state = state-1;
end
