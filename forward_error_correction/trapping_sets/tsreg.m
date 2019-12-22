%% E. Boutillon, C. Winstead.
%% Trapping set (5,3) analysis on NGDBF Algorithm.
%%
%% The state is represented by 5 bits that are initiate with wrong value.
%%          C1
%%          V1
%%       C2    C3 
%%    V2    C4    V3
%%    C5          C6
%%    V4    C7    V5
%%  C8              C9 
%%
%%    V1  V2  V3  V4  V5 V_dummy=1 
%% C1  1   0   0   0   0    
%% C2  1   1   0   0   0 
%% C3  1   0   1   0   0 
%% C4  0   1   1   0   0    
%% C5  0   1   0   1   0 
%% C6  0   0   1   0   1 
%% C7  0   0   0   1   1 
%% C8  0   0   0   1   0 
%% C9  0   0   0   0   1 
%%
%% Prob_correct, the output of the function, is the evolution in
% time of the probability of being correct (all errors corrected).
%%
%% The inputs are :
%%       w   : ponderation factor of sum of syndrom
%%     theta : decision factor.
%%       SNR : signal to noise ratio
%%     alpha : internal_sigma = alpha * channel_sigma.
%%         N : number of "iteration".
%%=============================================


function prob_transition = tsreg(H, dv, y, sigma, alpha, w, theta) 


% Definition of internal noise variance
sigma_0 = alpha*sigma;
N=length(y);

%=============================================================
% Computation of the probability of transition.
%=============================================================
% Formulae : If ( d*y + w*(s1 + s2 + s3) + noise  < theta)) then flip : 
%                                                         d = d*-1
% w is constant. y receive noise, d : local decision. s1, s2 and s3 = +1 if
% check correct, -1 otherwise.
%
% s3 is comming from the outside word of the trapping set : it is suppose
% alway equals to d (i.e., if d is +1 (correct), then check is correct +1,
% otherwise, check = -1).
%
% Thus the flip equation becomes : noise < \gamma, \gamma = theta - d*y - w(s1 + s2 + 1)
% then flip.
%
% This event has a probability \int_{-\inf}^{\gamma} N(0,\sigma_0)(t)dt.
% where \sigma_0 is the variance of the added noise. 
%
% This formula is computed as: 1/2*(1 + erf(\gamma/(sqrt(2)*\sigma_0)))
%
%Création of probably transition according to y and value of d : 6 lignes, 4 columns
%    according to s1 + s2 + s3 = {-3, -1, 1, 3}.


%% Computation of probability transistion as a function of y, theta, w, sum
%% of syndromes when local decision is +1 and when local decision is -1. 
for i = 1:length(y)
    d = -1; 
    sum_syndromes = -dv:2:dv;
    for j = 1:length(sum_syndromes)
        d = 1;
        gamma = theta -d*y(i) - w*sum_syndromes(j);
        if gamma < 0 
            prob_transition_plus1(i, j) = 1/2*(1 + erf(gamma/(sqrt(2)*sigma_0)));
        else
            prob_transition_plus1(i, j) = 1/2*(1 + erf(gamma/(sqrt(2)*sigma_0)));
        end
        d = -1;
        gamma = theta -d*y(i) - w*sum_syndromes(j);
        if gamma < 0
            prob_transition_minus1(i, j) = 1/2*(1 + erf(gamma/(sqrt(2)*sigma_0)));
        else
            prob_transition_minus1(i, j) = 1/2*(1 + erf(gamma/(sqrt(2)*sigma_0)));
        end;
    end;
end
%%
% function current_state => syndrome (i.e. check that are satisfied.
% Mc2v = 1 - 2*mod(H*[-1;-1;-1;-1;-1],2)
% Computation of sum of syndrome at state : line vector State of 5 bits. 
% syndrom : Mc2v'*H:
% Computation of syndrome for next iteration as a function of state.
for i = 0:(2^N-1)
    state = de2bi(i,length(y)); %1 - 2*(dec2bin(i,5) - char(1) -
                               %47);
    state = state(N:-1:1);
    Mc2v = 1-2*(mod(H*state',2));
    syndrom(i+1,:)= Mc2v'*H;
end

% Definition of transition matrix
for i = 0:(2^N-1)
    initial_state_bin = de2bi(i,N);    
    initial_state_bin = initial_state_bin(N:-1:1);
    initial_state = 1 - 2*initial_state_bin;
    for j = 0:(2^N-1)
        final_state_bin = de2bi(j,N);
        final_state_bin = final_state_bin(N:-1:1);
        final_state = 1 - 2*final_state_bin;
        prob = 1;
        for k = 1:N
            weight = syndrom(i+1,k);    % Takes value -3 -1 1 3
            ind_w = (dv+weight)/2 + 1; % index of weight between 1 to 4
            if (initial_state(k) == 1)
                if (final_state(k) == 1)
                   prob = prob*(1 - prob_transition_plus1(k, ind_w));
                else
                   prob = prob*prob_transition_plus1(k, ind_w);
                end
            else
                if (final_state(k) == -1)
                   prob = prob*(1 - prob_transition_minus1(k, ind_w));
                else
                   prob = prob*prob_transition_minus1(k, ind_w);
                end
            end
        end
    prob_transition(i+1, j+1) = prob;    
    end
end


