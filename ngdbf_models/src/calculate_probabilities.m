function [p,status] = calculate_probabilities(energies,theta,sigma,sym_size)
    begin = time();
    p = ones(2^sym_size,2^sym_size);
    p_test = ones(2^sym_size,2^sym_size);
    % Flip probabilities calculated according to Eq 3.13 in T. Tithi
    % dissertation (pg. 26)
    % Calculate individual bit flipping probabilities
    p_flip = normcdf(theta,energies,sigma);
    bin_pos = dec2bin(0:(2^sym_size-1));
    for row = 1:2^sym_size
        %rowbin = dec2bin(row-1,sym_size);
        for col = 1:2^sym_size
            %colbin = dec2bin(col-1,sym_size);
            y = (bin_pos(row,:)==bin_pos(col,:));
            p(row,col) = prod(abs(1-(mod(y+1,2)+p_flip(row,:))));
            % for p_idx = 1:sym_size
            %     if bin_pos(row,p_idx) == bin_pos(col,p_idx)
            %         p(row,col) = p(row,col)*(1-p_flip(row,p_idx));
            %     else
            %         p(row,col) = p(row,col)*p_flip(row,p_idx);
            %     end
            % end
        end
    end
    % p_test 
    % p 
    % p == p_test
    % sum(p_test.')
    % pause;
    % Sanity check
    if sum(round(sum(p.'))) ~= 2^sym_size
        fprintf("Error: Probabilities do not sum to 1\n");
        sum(p.')
        status = -1;
    else
        status = 0;
    end
    end_time = time();
    fprintf("probability calculation took %d seconds\n",end_time-begin);
endfunction