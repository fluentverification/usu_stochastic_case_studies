#! /bin/octave -qf
addpath(genpath(pwd));
load_trapping_sets;

# --engine [prism/storm] -e
# --runs -n
# --trapping-set -m
# --sigma -d
# --code-rate -R
# --SNR -s 
# --threshold -t
# --property -p
# --weight -w

run_ngdbf_storm(eight_eight);