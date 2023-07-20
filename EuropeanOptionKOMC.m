function optionPrice = EuropeanOptionKOMC(F0,K, KI,B,T,sigma,N)
% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% N: number of simulations in MC   
% flag:  1 call, -1 put

%generating a vector of random normal W
W=sqrt(T)*randn(1,N);

%computing the Forward Rates
Ft=F0*exp(-0.5*sigma^2*(T)+sigma*W);

%Option Price
PayOff = max(Ft-K,0).*(Ft<KI);
optionPrice = mean(B*PayOff);

end