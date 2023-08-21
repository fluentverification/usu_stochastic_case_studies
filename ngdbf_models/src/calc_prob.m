function [p,status] = calc_prob(energies,theta,sigma,sym_size)
    % begin = time();
    % Calculate individual bit flipping probabilities
    p_flip = normcdf(theta,energies,sigma);

    %Initialize prob matrix
    p = ones(2^sym_size,2^sym_size);
    p_test = ones(2^sym_size,2^sym_size);
    % Flip probabilities calculated according to Eq 3.13 in T. Tithi
    % dissertation (pg. 26)
    bin_pos = dec2bin(0:(2^sym_size-1));
    for row = 1:2^sym_size
        for col = 1:2^sym_size
            y = (bin_pos(row,:)==bin_pos(col,:));
            p(row,col) = prod(abs(1-(mod(y+1,2)+p_flip(row,:))));
        end
    end
  
    % Sanity check
    if sum(round(sum(p.'))) ~= 2^sym_size
        fprintf("Error: Probabilities do not sum to 1\n");
        sum(p.')
        status = -1;
    else
        status = 0;
    end
    % end_time = time();
    %fprintf("probability calculation took %d seconds\n",end_time-begin);

endfunction