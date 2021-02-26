fname='comm_model.dot';
pngname=sprintf('%s.png',fname);

allowed_transitions=[
   0 1
   1 3
   3 7
   3 2
   7 6
   2 6
   6 14
   6 8
   8 12
   14 12
   12 13
   4 5
   5 13
   13 9
   14 8
   8 0
   8 9
   9 1
   9 11
   11 3
];

allowed_nodes = unique(allowed_transitions);
forbidden_nodes = setdiff(0:15,allowed_nodes);

fid=fopen(fname,'w');

fprintf(fid,"digraph G {\n   rankdir=LR;\n");
fprintf(fid,"  subgraph cluster_A {\n   rankdir=LR;\n");
for x=1:numel(allowed_nodes);
    fprintf(fid,'     %d%d%d%d [ color="green" ];\n',fliplr(de2bi(allowed_nodes(x),4)));
end
fprintf(fid,"   };\n");
for x=0:15
    if (~ any(allowed_nodes==x))
        fprintf(fid,'   %d%d%d%d [ color="red" ];\n',fliplr(de2bi(x,4)));
    end
end

for a=0:15
    for b=0:15
        s = fliplr(de2bi(a,4));
        t = fliplr(de2bi(b,4));
        if (sum(s ~= t)==1) 
            fprintf(fid,"   %d%d%d%d -> %d%d%d%d",s,t);
            if (ismember([a b],allowed_transitions,'rows'))                
                fprintf(fid, ' [ color = "green" ];\n');
            else
                fprintf(fid, ' [ color = "red" ];\n');
            end
        end
    end
end
fprintf(fid,"}\n");

cmd=sprintf("/usr/local/bin/dot -Tpng -O %s",fname);
system(cmd);
image(imread(pngname));