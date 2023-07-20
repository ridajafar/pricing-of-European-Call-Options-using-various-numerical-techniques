function optionPrice=EuropeanOptionKOCRR(F0,K, KI,B,T,sigma,N)
% INPUT:
% F0:       forward price
% B:        discount factor
% K:        strike
% KI:       barrier (up and out)
% T:        time-to-maturity
% sigma:    volatility
% N:        number of time steps

%% Parameters
dt = T/N;                   % discrete time step
u = exp(sigma*sqrt(dt));    % upward movement
d = 1/u;                    % downward movement
q = (1-d)/(u-d);            % probability of upward movement


%% Building the tree 

% Forward at maturity
F = F0*u.^(-N:2:N);

% Payoff at maturity
p = max(F-K,0).*(KI>F);

% Backward in time procedure
for n = N:-1:1
    p = q*p(2:n+1)+(1-q)*p(1:n);
end

% Discounted option price
optionPrice = B*p;


end