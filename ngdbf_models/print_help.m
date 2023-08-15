function print_help
    fprintf("\nERROR: Not enough arguments\n");
    fprintf("Usage: run_ngdbf(adj_mat,explicit_model,finish_condition) \nadj_mat: Adjacency Matrix of trapping set to analyze.");
    fprintf(" You may load trapping sets with load_trapping_sets.m\nexplicit_model: Optional, "); 
    fprintf("if true then explicit model files are generated. False by default.\n");
    fprintf("finish_condition: If true, the simulation will stop in all-zero state. True by default.\n\n");
endfunction