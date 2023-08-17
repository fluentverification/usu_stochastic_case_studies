clc;
    % Ask for inputs
    fprintf("Default Values\n");
    fprintf("Code Rate = 0.8413\n");
    fprintf("SNR = 4.5\n");
    fprintf("Threshold = -0.55\n");
    fprintf("Weight = 1/6 (%f) \n",1/6);
    fprintf("Transient probability calculation with 600 iterations ( -tr 600 ) \n");
    check = input("Would you like to use the default values [y/n]? ","s");
    if isempty(check)
        check = 'y';
    end
    code_rate = [];
    SNR = [];
    theta = [];
    w = [];
    tag = [];
    if check ~= 'y'
        fprintf("Press enter to use default value\n");
        code_rate = input("Enter a new code rate: ");
        SNR = input("Enter a new SNR: ");
        theta = input("Enter a new threshold: ");
        w = input("Enter a new weight: ");
        tag = input("Enter a new simulation tag or property (ie -tr 500, -ss, -prop <property>, etc...) Must have a leading space: ",'s');
    end
  
    if isempty(code_rate)
        code_rate=0.8413;
    end
    if isempty(SNR)
        SNR = 4.5;
    end   
    if isempty(theta)
        theta = -0.55;
    end
    if isempty(w)
        w = 1/6;
    end
    if isempty(tag)
        tag = ' "P=? [ true U[0,600] (state=0) ]"';
    end