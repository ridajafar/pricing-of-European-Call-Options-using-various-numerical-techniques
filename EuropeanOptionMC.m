function optionPrice = EuropeanOptionMC(F0,K,B,T,sigma,N,flag)

% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% pricingMode: 1 ClosedFormula, 2 CRR, 3 Monte Carlo
% N: number of simulations in MC   
% flag:  1 call, -1 put

%generating a vector of random normal W
W=randn(1,N);

%computing the Forward
Ft=F0*exp(-0.5*sigma^2*(T)+sigma*sqrt(T)*W);

%Option Price
optionPrice = mean(B*max(flag*(Ft-K),0));

end


