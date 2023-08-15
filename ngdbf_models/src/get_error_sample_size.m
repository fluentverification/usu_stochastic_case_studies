function sum = get_error_sample_size(bits) 
    sum = 0;
    for n=1:2^bits
        str = dec2bin(n-1,bits);
        for k = 1:length(str)
            if str(k) == '1'
                sum = sum + 1;
            end
        end
    end

end
