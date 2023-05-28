function [status,state] = write_model(fileName,y1,y2,y3,p)
    arguments
        fileName string
        y1 double
        y2 double
        y3 double
        p (8,8) double
    end
    if y1 > 0
        x1 = 0;
    else
        x1 = 1;
    end
    if y2 > 0
        x2 = 0;
    else
        x2 = 1;
    end
    if y3 > 0
        x3 = 0;
    else
        x3 = 1;
    end
    state = round((x3*1+x2*2+x1*4)+1);
    fid = fopen(fileName,'w');
    fprintf(fid,"dtmc\n\n");
    fprintf(fid,"formula s1 = mod(x2+x3,2);\n");
    fprintf(fid,"formula s2 = mod(x1+x3,2);\n");
    fprintf(fid,"formula s3 = mod(x1+x3,2);\n");
    fprintf(fid,"formula s4 = x1;\n");
    fprintf(fid,"formula s5 = x2;\n");
    fprintf(fid,"formula s6 = x3;\n");
    %fprintf(fid,"formula done = (s1 = 0) & (s2 = 0) & (s3 = 0)& (s4=0) & (s5 = 0) & (s6 = 0);//(state=1);\n\n");
    fprintf(fid,"module trapping_set \n");
    fprintf(fid,"\tstate : [1..8] init %d;\n",state);
    fprintf(fid,"\tx1 : [0..1] init %d;\n",x1);
    fprintf(fid,"\tx2 : [0..1] init %d;\n",x2);
    fprintf(fid,"\tx3 : [0..1] init %d;\n",x3);
    fprintf(fid,"\thalt : bool init false;\n\n");
    %fprintf(fid,"\t[finish] done -> 1:(halt' = true);\n");
    for i = 1:8
        if i ~= 1
            fprintf(fid,"\t[] state=%d -> ",i);
            for j=1:8
                fprintf(fid,"%.8f:(state'=%d)",p(i,j),j);
                cur_state = dec2bin(i-1,3);
                update_state = dec2bin(j-1,3);
                if cur_state(1) ~= update_state(1)
                    fprintf(fid,"&(x1' = mod(x1+1,2))");
                end
                if cur_state(2) ~= update_state(2)
                    fprintf(fid,"&(x2' = mod(x2+1,2))");
                end
                if cur_state(3) ~= update_state(3)
                    fprintf(fid,"&(x3' = mod(x3+1,2))");
                end
                if j ~= 8
                    fprintf(fid,"+");
                end
            end
        else
            fprintf(fid,"\t[finish] state=%d -> 1: (halt' = true) ",i);
        end
        
        fprintf(fid,";\n");
    end

    fprintf(fid,"endmodule\n");
    status = 0;
    fclose(fid);

end
