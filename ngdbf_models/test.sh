#!/bin/octave -qf

# Add src folder to path
addpath("./src");
pkg load statistics;
clc;
# get cmd line arguments
arglist = argv ();
for idx = 1:2:nargin
    switch(arglist{idx})
        case {'--engine','-e'}
            idx = idx+1;
            engine = arglist{idx};
        case {'--runs','-r'}
            idx = idx+1;
            runs = str2double(arglist{idx});
        case {'--trapping_set','-m'}
            idx = idx+1;
            adj_mat = load_trapping_sets(arglist{idx});
            [~,bit_length] = size(adj_mat);
        case {'--code_rate','-R'}
            idx = idx+1;
            code_rate = str2double(arglist{idx});
        case {'--SNR','-s'}
            idx = idx+1;
            SNR = str2double(arglist{idx});
        case {'--threshold','-t'}
            idx = idx+1;
            threshold = str2double(arglist{idx});
        case {'--property','-p'}
            idx = idx+1;
            prop = arglist{idx};
            prop = [' ' prop];
        case {'--weight','-w'}
            idx = idx+1;
            w = str2double(arglist{idx});
        otherwise
            fprintf("%s is an invalid tag\n Use --help or -h to print options\n",arglist{idx});
            return;
    end
end


# validate cmd-line arguments and set defaults
if ~exist('engine') || ~exist('adj_mat') || ~exist('runs')
    print_help();
    return;
end
if ~exist('code_rate')
    code_rate = 0.8413;
end 
if ~exist('SNR')
    SNR = 4.5;
end
if ~exist('threshold')
    threshold = -0.55;
end
if ~exist('prop')
    prop = ' decode.pctl';
end
if ~exist('w')
    w = 1/6;
end

sigma = sqrt(1/code_rate)*10^(-SNR/20);
[~,sym_size] = size(adj_mat);
# Run simulations and take average
prob_sum = zeros(2^bit_length,2^bit_length);
for idx = 1:runs
    if strcmp(engine,'prism') == 1
        prob_sum = prob_sum+run_ngdbf_prism(adj_mat,sigma,threshold,w,prop);
    elseif strcmp(engine,'storm') == 1
        prob_sum = prob_sum+run_ngdbf_storm(adj_mat,sigma,threshold,w,prop);
    else
        fprintf("comparison not working\n");
        return;
    end
end



avg_prob = prob_sum/runs
format long
Perr = 1-avg_prob(:,1)
if strcmp(engine,"storm") == 1
    Perr = Perr(:,1);
end
sum(Perr)