function E = calculate_energies(adj_mat,channel_samples,weight,sym_size,check_size)
    % begin = time();
    %%%%%%%%%%%%%%%%%%%%% Create state matrix %%%%%%%%%%%%%%%%%%%%%%%%%
    % States taken from Tasnuva dissertation (Table 3.1, pg 27)
    x_str = [dec2bin(0:(2^sym_size)-1,sym_size)];
    x = zeros(2^sym_size,sym_size);
    % convert to bipolar states
    for row = 1:2^sym_size
        for col = 1:sym_size
                x(row,col) = str2double(x_str(row,col));
            if x(row,col) == 1
                x(row,col) = -1;
            else
                x(row,col) = 1;
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    E = zeros(2^sym_size,sym_size);
    % Calculate all possible energy values for each state
    chk_nodes = ones(2^sym_size, check_size);
    chk_sum = zeros(2^sym_size,sym_size);
    for row = 1:2^sym_size
        % chk_nodes = ones(1, check_size);
        % chk_sum = zeros(1,sym_size);
        % Calculate all check nodes
        for adj_row = 1:check_size
            for adj_col = 1:sym_size
                if adj_mat(adj_row,adj_col) == 1
                    chk_nodes(row,adj_row) = chk_nodes(row,adj_row)*x(row,adj_col);
                    % chk_nodes(adj_row) = chk_nodes(adj_row)*x(row,adj_col);
                end
            end
        end
        % Calculate all sums
        for adj_row = 1:check_size
            for adj_col = 1:sym_size
                if adj_mat(adj_row,adj_col) == 1
                    % chk_sum(adj_col) = chk_sum(adj_col)+chk_nodes(adj_row);
                    chk_sum(row,adj_col) = chk_sum(row,adj_col)+chk_nodes(row,adj_row);
                end
            end
        end
        % Calculate Energies
        for E_idx = 1:sym_size
            E(row,E_idx) = channel_samples(E_idx)*x(row,E_idx)+weight*chk_sum(row,E_idx);
            % E(row,E_idx) = channel_samples(E_idx)*x(row,E_idx)+weight*chk_sum(E_idx);
        end
    end
    % E_end = time();
    % fprintf("Energy calculation took %d seconds\n",E_end-begin);
endfunction