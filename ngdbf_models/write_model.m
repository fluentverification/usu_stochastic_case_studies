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
    fprintf(fid,"module trapping_set \n");
    fprintf(fid,"\tstate : [1..%d] init %d;\n",2^y_size,state);
    %fprintf(fid,"\thalt : bool init false;\n\n");
    %fprintf(fid,"\t[finish] done -> 1:(halt' = true);\n");
    for i = 1:2^y_size
        if i ~= 1
            fprintf(fid,"\t[] state=%d -> ",i);
            for j=1:2^y_size
                fprintf(fid,"%.16f:(state'=%d)",p(i,j),j);
                if j ~= 2^y_size
                    fprintf(fid,"+");
                end
            end
        else
            %fprintf(fid,"\t[finish] state=%d -> 1: (halt' = true) ",i);
            fprintf(fid,"\t[finish] state=%d -> 1: (state' = 1) ",i);
        end
        
        fprintf(fid,";\n");
    end

    fprintf(fid,"endmodule\n");
    status = 0;
    fclose(fid);

end
