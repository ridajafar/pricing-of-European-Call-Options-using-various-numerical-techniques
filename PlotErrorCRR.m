function [M,errorCRR]=PlotErrorCRR(F0,K,B,T,sigma)

% INPUT:
% F0:    forward price
% B:     discount factor
% K:     strike
% TTM:     time-to-maturity
% sigma: volatility
%
% OUTPUT:
% nCRR: vector of number of simulations 
% errCRR: vector of std deviation of MC considering the number of simulations

% Computing the price with the closed formula
exact_value = EuropeanOptionClosed(F0,K,B,T,sigma,1); 

% Creating the array of samples
m=1:9;
M=2.^m;
errorCRR=zeros(length(M));

% Computing std dev for each nMC
for i=1:length(M)
    CRR_value = EuropeanOptionCRR(F0,K,B,T,sigma,M(i),1); % price computed using the CRR method
    errorCRR(i) = abs(CRR_value-exact_value); % error of the CRR method 
end

figure
% Plotting y=-x to see if they have the same slope
Y=M.^-1;
loglog(M,Y)
hold on

% Plotting the estimator as function of the number of simulations (logscale)
loglog(M,errorCRR,'-o')
hold off
legend('y = - x','Unbiased Standard Deviation estimator')
xlabel('Steps')
ylabel('Error')


end