function [p,status] = calculate_probabilities(energies,theta,sigma,sym_size)
    p = ones(2^sym_size,2^sym_size);
    % Flip probabilities calculated according to Eq 3.13 in T. Tithi
    % dissertation (pg. 26)
    for row = 1:2^sym_size
        px = zeros(1,sym_size);
        for p_idx = 1:sym_size
            px(p_idx) = normcdf(theta,energies(row,p_idx),sigma);
        end
        rowbin = dec2bin(row-1,sym_size);
        for col = 1:2^sym_size
            colbin = dec2bin(col-1,sym_size);
            for p_idx = 1:sym_size
                if rowbin(p_idx) == colbin(p_idx)
                    p(row,col) = p(row,col)*(1-px(p_idx));
                else
                    p(row,col) = p(row,col)*px(p_idx);
                end
            end
        end
    end
    % Sanity check
    if sum(round(sum(p.')),2) ~= 2^sym_size
        fprintf("Error: Probabilities do not sum to 1\n");
        status = -1;
    end
    status = 0;
endfunction