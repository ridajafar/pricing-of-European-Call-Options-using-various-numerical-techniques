function [M,stdEstim] = PlotErrorMC(F0,K,B,T,sigma)

% INPUT:
% F0:       forward price
% B:        discount factor
% K:        strike
% TTM:      time-to-maturity
% sigma:    volatility
%
% OUTPUT:
% nMC:      vector of number of simulations 
% stdEstim: vector of std deviation of MC considering the number of simulations

% Creating the array of samples
m=1:20;
M=2.^m;
stdEstim=zeros(length(M));

% Computing std dev for each nMC
for i=1:length(M) 
    W=sqrt(T)*randn(1,M(i));
    %Computing the Forward Rates
    Ft=F0*exp(-0.5*sigma^2*(T)+sigma*W);
    %Unbiased estimator
    stdEstim(i)= std(B*max((Ft-K),0))/sqrt(M(i));
end


figure
% Plotting y=-x/2 to see if they have the same slope
Y=sqrt(M).^-1;
loglog(M,Y)
hold on

% Plotting the estimator as function of the number of simulations (logscale)
loglog(M,stdEstim,'-o')
hold off
legend('y = -1/2 x','Unbiased Standard Deviation estimator')
xlabel('Steps')
ylabel('Error')

end


    