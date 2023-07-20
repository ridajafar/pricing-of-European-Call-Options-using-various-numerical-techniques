function optionPrice = BermudanOption(F0,K,B,T,sigma,N,flag)
% Bermudan option price with possible early exercise in one point
%
% INPUT
% F0:    forward price
% B:     discount factors
% K:     strike
% T:     exercise date and time-to-maturity 
% sigma: volatility
% flag:  1 call, -1 put
% N:     number of time steps


%% Parameters
dt = T(end)/N;              
% discrete time step
u = exp(sigma*sqrt(dt));    % upward movement
d = 1/u;                    % downward movement
q = (1-d)/(u-d);            % probability of upward movement


%% Building the tree 

% Forward at exercise times
F = F0*u.^(-N:2:N);
F1 = F0*u.^(-floor(N*T(1)/T(end)) : 2 : floor(N*T(1)/T(end)));

% Payoff at exercise times
p = max(flag*(F-K),0);

% Backward in time procedure
for n = N:-1:1
    if n == (floor(N*T(1)/T(end))+1)
        p = max( B(end)^(1/N)*(q*p(2:n+1)+(1-q)*p(1:n)) , flag*(F1-K) );
    else
        p = B(end)^(1/N)*(q*p(2:n+1)+(1-q)*p(1:n));
    end
end

% Discounted option price
optionPrice = p;


end 
