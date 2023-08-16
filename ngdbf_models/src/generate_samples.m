function [valid_samples,error_samples,valid_idx,error_idx]  = generate_samples(sym_size,sigma)
    loop_check = get_error_sample_size(sym_size);
    valid_samples = zeros(1,loop_check);
    valid_idx = 1;
    error_samples = zeros(1,loop_check);
    error_idx = 1;
    while valid_idx <= loop_check || error_idx <= loop_check
        temp = normrnd(1,sigma);
        if temp > 0
            valid_samples(valid_idx) = temp;
            valid_idx = valid_idx +1;
        end
        if temp < 0
            error_samples(error_idx) = temp;
            error_idx = error_idx+1;
        end
    end
endfunction