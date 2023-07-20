% Assignment_1
% Group 7, AA2022-2023
%


%%
clear ; clc; format long;

%% Pricing parameters
S0=1;
K=1;
r=0.04;
TTM=1/6; 
sigma=0.30;
flag=1; % flag:  1 call, -1 put
d=0.05;
Num_contracts=1e6;

%% Quantity of interest
B=exp(-r*TTM); % Discount

%% Pricing 
F0=S0*exp(-d*TTM)/B;     % Forward in G&C Model
OptionPrice = zeros(3,1);

for i=1:3
    pricingMode = i; % 1 ClosedFormula, 2 CRR, 3 Monte Carlo
    M=100; % M = simulations for MC, steps for CRR;
    OptionPrice(i) = EuropeanOptionPrice(F0,K,B,TTM,sigma,pricingMode,M,flag);
end

% Display prices
disp('Unitary prices:')
fprintf('The price with the closed formula is %d\n', OptionPrice(1));
fprintf('The price with the CRR tree is %d\n', OptionPrice(2)); 
fprintf('The price with the MC simulation is %d\n\n', OptionPrice(3)); 
disp('Prices:')
fprintf('The price with the closed formula is %d\n', OptionPrice(1)*Num_contracts);
fprintf('The price with the CRR tree is %d\n', OptionPrice(2)*Num_contracts); 
fprintf('The price with the MC simulation is %d\n\n', OptionPrice(3)*Num_contracts); 

% Compute Errors
disp('Errors:')
% CRR tree
CRR_error = abs(OptionPrice(2)-OptionPrice(1));
fprintf('The error with the CRR tree is %d\n', CRR_error);
% MC simulation for the unbiased std dev
M=1e6;
FT=F0*exp(-sigma^2/2*TTM+sigma*sqrt(TTM)*randn(M,1));
stdEst =std(B*max(FT-K,0))/sqrt(M);
fprintf('The error with the MC simulation is %d\n\n', stdEst);


%% Errors Rescaling 

% plot Errors for CRR varing number of steps
% Note: both functions plot also the Errors of interest as side-effect 
[nCRR,errCRR]=PlotErrorCRR(F0,K,B,TTM,sigma);

% plot Errors for MC varing number of simulations N 
[nMC,stdEstim]=PlotErrorMC(F0,K,B,TTM,sigma); 

%% KO Option

KO = 1.2;

% CRR method

M=100;
optionPriceCRR=EuropeanOptionKOCRR(F0,K, KO,B,TTM,sigma,M);

% MC simulation

M=1e6;
optionPriceMC = EuropeanOptionKOMC(F0,K, KO,B,TTM,sigma,M);

% Closed formula

% Calls for bear spread
call1 = EuropeanOptionClosed(F0,K,B,TTM,sigma,1);
call2 = EuropeanOptionClosed(F0,KO,B,TTM,sigma,1);

% Digital option
d2=log(F0/KO)/sigma/sqrt(TTM)-0.5*sigma*sqrt(TTM);
DigitalOptionPrice=(KO-K)*B*normcdf(d2,0,1); %cdf('normal',d2,0,1) più lenta %% discount makes sense but check again

% Closed price
optionPriceClosed= call1-call2-DigitalOptionPrice;

% Display results
disp('KO option prices:')
fprintf('The price with the MC simulation is %d\n', optionPriceMC*Num_contracts); 
fprintf('The price with the CRR tree is %d\n', optionPriceCRR*Num_contracts); 
fprintf('The price with the closed formula is %d\n\n', optionPriceClosed*Num_contracts); 


%% KO Option Gamma

S0_gamma=0.7:0.025:1.35;
F0_gamma=S0_gamma*exp(-d*TTM)/B;
% 1 CRR, 2 Monte Carlo, 3 Closed Formula
M=100; % M = simulations for MC, steps for CRR;
% the functions gamma has as input F0 and they calculate the derivative
% w.r.t. F0 so after that we need to multiply for the dF0/dS0
gammaCRR = ((exp(-d*TTM)/B)^2)*GammaKO(F0_gamma,K, KO,B,TTM,sigma,M,1);
gammaMC = ((exp(-d*TTM)/B)^2)*GammaKO(F0_gamma,K, KO,B,TTM,sigma,M,2);
gammaCL = ((exp(-d*TTM)/B)^2)*GammaKO(F0_gamma,K, KO,B,TTM,sigma,M,3);
gammaCL_fo = (exp(-2*d*TTM)/B)*GammaKO(F0_gamma,K, KO,B,TTM,sigma,M,4);

figure;
plot(S0_gamma,gammaCL_fo,'-o');
hold on;
plot(S0_gamma(2:end-1),gammaCL,'-o');
legend('gammaCLex','gammaCL');
hold off;


figure;
plot(S0_gamma(2:end-1),gammaCL,'-o');
hold on;
plot(S0_gamma(2:end-1),gammaCRR,'-x');
hold on;
plot(S0_gamma(2:end-1),gammaMC,'-h');
legend('gammaCL','gammaCRR','gammaMC');
hold off;

%% Antithetic Variables

% AV simulation
M=1e6;
Z=randn(M,1);
FT=F0*exp(-sigma^2/2*TTM+sigma*sqrt(TTM)*Z);
FT_AV=F0*exp(-sigma^2/2*TTM+sigma*sqrt(TTM)*(-Z));

% Compute payoffs
DiscountedPayoff = B*max(FT-K,0);
DiscountedPayoffAV = B*max(FT_AV-K,0);

% Compute estimate for AV std dev
stdEst =std((DiscountedPayoff+DiscountedPayoffAV)/2)/sqrt(M);
fprintf('The error with the AV MC simulation is %d\n\n', stdEst);

%% Bermudan Option

M = 100;
OptionPrice = BermudanOption(F0,K,B,[TTM/2 TTM],sigma,M,flag); 
% General for any fraction of the any expiry and for any number of expiry
% times: we can observe that the more expiries we add the more the price
% will increase, as it is logical
fprintf('The price with the CRR tree of the Bermudan option is %d\n\n', OptionPrice*Num_contracts);
