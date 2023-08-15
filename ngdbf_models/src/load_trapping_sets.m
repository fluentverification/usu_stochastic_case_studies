% Trappping sets from University of Arizona
% https://uweb.engr.arizona.edu/~vasiclab/Projects/CodingTheory/TrappingSetOntology.html 

% Adjacency matrix structure
%    s_1 s_2 s_3 ... s_n
% c_1
% c_2
% c_3
%  |
% c_n
fprintf("\n\nTo use trapping sets call <strong>run_ngdbf(trapping_set,explicit_model,finish_condition)</strong> where trapping_set \nis one the loaded sets, explicit_model is a boolean\nthat is true if you would like to generate an explicit model \n(see PRISM manual for more info on explicit models\nhttps://www.prismmodelchecker.org/manual/Appendices/ExplicitModelFiles)\nor false if you would like to generate a normal .prism model. \nfinish_condition is a boolean that indicates you want the simulation to end if the all-zero state is reached.\n\n\n");
fprintf("Currently Available Sets\n");
fprintf("(3,3) = three_three\n");
three_three = [
1 0 0 
1 1 0
0 1 0
1 0 1
0 1 1
0 0 1
];

fprintf("(4,4) = four_four\n");
four_four = [    
1 1 0 0
0 1 1 0
0 0 1 1
1 0 0 1 
1 0 0 0
0 1 0 0
0 0 1 0
0 0 0 1
];

fprintf("(5,3) = five_three\n");
five_three = [
1 1 0 0 0
1 0 1 0 0
1 0 0 1 0
0 1 0 0 0
0 0 1 0 0
0 0 0 1 0
0 1 0 0 1
0 0 1 0 1 
0 0 0 1 1
];

fprintf("(6,4){4} = six_four_four\n");
six_four_four = [
1 1 0 0 0 0
1 0 0 1 0 0
1 0 0 0 1 0
0 1 0 0 0 0
0 0 0 1 0 0
0 1 1 0 0 0
0 0 1 1 0 0
0 0 1 0 0 1
0 0 0 0 1 0
0 0 0 0 0 1
0 0 0 0 1 1
];

fprintf("(6,4){8} = six_four_eight\n");
six_four_eight = [
1 0 0 1 0 0
1 0 0 0 0 0
1 1 0 0 0 0
0 1 0 0 0 0
0 1 1 0 0 0 
0 0 1 0 0 1
0 0 1 1 0 0
0 0 0 1 1 0
0 0 0 0 1 0 
0 0 0 0 1 1
0 0 0 0 0 1
];

fprintf("(6,2) = six_two\n");
six_two = [
1 1 0 0 0 0
1 0 0 0 1 0
1 0 0 0 0 1
0 1 1 0 0 0 
0 0 1 0 0 0
0 0 1 0 1 0
0 0 0 0 0 1
0 1 0 1 0 0
0 0 0 1 1 0
0 0 0 1 0 1
];

fprintf("(6,0) = six_zero\n");
six_zero = [
1 0 0 1 0 0
1 0 0 0 1 0
1 0 0 0 0 1
0 1 0 1 0 0 
0 1 0 0 1 0
0 1 0 0 0 1
0 0 1 1 0 0 
0 0 1 0 1 0
0 0 1 0 0 1
];


fprintf("(7,5){3} = seven_five_three\n");
seven_five_three = [
1 0 0 0 0 0 1
1 0 0 0 1 0 0
1 1 0 0 0 0 0
0 1 0 0 0 0 0
0 1 1 0 0 0 0
0 0 1 0 0 0 0
0 0 1 1 0 0 0
0 0 0 1 0 0 0
0 0 0 1 1 0 0
0 0 0 0 1 1 0
0 0 0 0 0 1 0 
0 0 0 0 0 1 1
];

fprintf("(7,5){6} = seven_five_six\n")
seven_five_six = [
1 0 0 0 0 1 0
1 0 0 0 0 0 1
1 1 0 0 0 0 0
0 1 0 0 0 0 0
0 1 1 0 0 0 0
0 0 1 0 0 0 0
0 0 1 1 0 0 0
0 0 0 1 0 0 0 
0 0 0 1 1 0 0
0 0 0 0 1 0 1
0 0 0 0 1 1 0
0 0 0 0 0 1 0
0 0 0 0 0 0 1
];

fprintf("(7,3){3} = seven_three_three\n");
seven_three_three = [
1 0 0 0 1 0 0
1 0 0 0 0 1 0
1 1 0 0 0 0 0
0 1 0 0 0 0 1
0 1 1 0 0 0 0
0 0 1 0 0 0 0
0 0 0 1 0 1 0
0 0 0 1 1 0 0 
0 0 0 0 1 0 0
0 0 0 0 0 1 1
0 0 0 0 0 0 1
];

fprintf("(7,3){4} = seven_three_four\n");
seven_three_four = [
1 0 0 0 1 0 0 
1 0 0 0 0 0 1
1 1 0 0 0 0 0
0 1 0 0 0 0 0
0 1 1 0 0 0 0
0 0 1 0 0 0 0
0 0 1 1 0 0 0 
0 0 0 1 0 0 1 
0 0 0 1 1 0 0 
0 0 0 0 1 1 0
0 0 0 0 0 1 0
0 0 0 0 0 1 1
];

fprintf("(7,3){10} = seven_three_ten");
seven_three_ten = [
1 0 0 1 0 0 0
1 0 0 0 0 0 0
1 1 0 0 0 0 0
0 0 0 1 1 0 0
0 0 0 0 1 0 0
0 0 0 0 1 1 0
0 0 0 0 0 1 1
0 0 0 0 0 0 1
0 1 0 0 0 0 1
0 0 1 1 0 0 0
0 0 1 0 0 1 0
0 1 1 0 0 0 0 
];

fprintf("(7,1){1} = seven_one_one\n")
seven_one_one = [
1 0 0 0 1 0 0 
1 0 0 0 0 1 0
1 1 0 0 0 0 0
0 0 0 0 1 0 1
0 0 0 0 0 1 1
0 1 0 0 0 0 1
0 0 0 1 1 0 0 
0 0 0 1 0 1 0
0 0 1 1 0 0 0
0 0 1 0 0 0 0
0 1 1 0 0 0 0
];

fprintf("(8,6){4} = eight_six_four\n");
eight_six_four = [
1 0 0 0 0 0 0 1
1 0 0 0 0 1 0 0
1 1 0 0 0 0 0 0
0 1 0 0 0 0 0 0
0 1 1 0 0 0 0 0
0 0 1 0 0 0 0 0 
0 0 1 1 0 0 0 0
0 0 0 1 0 0 0 0
0 0 0 1 1 0 0 0
0 0 0 0 1 0 0 0
0 0 0 0 1 1 0 0
0 0 0 0 0 1 1 0 
0 0 0 0 0 0 1 1
0 0 0 0 0 0 0 1
];