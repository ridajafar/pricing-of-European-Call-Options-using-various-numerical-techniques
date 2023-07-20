function gamma = GammaKO(F0,K, KO,B,T,sigma,N,flagNum)
%Gamma of the option price
%
%INPUT
% F0:    spot price
% B:     discount factor
% K:     strike
% T:     time-to-maturity
% sigma: volatility
% flagNum: flagNum=1 CRR, flagNum=2 MC,  flagNum=3 Exact.

switch flagNum
    case 1
        %gamma=GammaKOCRR(F0,K, KO,B,T,sigma,N);
        % Computing the prices of the barrier option at each forward rate
        optionPrice_KO_CRR=zeros(1,length(F0));
        for i=1:length(F0)
            optionPrice_KO_CRR(1,i) = EuropeanOptionKOCRR(F0(i),K, KO,B,T,sigma,N);
        end

        % Computing the second derivative numerically
        deltaF = (F0(2) - F0(1));
        h2 = deltaF^2;
        gamma = (optionPrice_KO_CRR(1:end-2)-2*optionPrice_KO_CRR(2:end-1)+optionPrice_KO_CRR(3:end))/(h2);

    case 2
        %gamma=GammaKOMC(F0,K, KO,B,T,sigma,N);
        % Computing the prices of the barrier option at each forward rate
        optionPrice_KO_MC=zeros(1,length(F0));
        for i=1:length(F0)
            optionPrice_KO_MC(1,i) = EuropeanOptionKOMC(F0(i),K, KO,B,T,sigma,N*1e4);
        end

        % Computing the second derivative numerically
        deltaF = (F0(2) - F0(1));
        h2 = deltaF^2;
        gamma = (optionPrice_KO_MC(1:end-2)-2*optionPrice_KO_MC(2:end-1)+optionPrice_KO_MC(3:end))./h2;

    case 3
        % Computing the prices of the barrier option at each forward rate
        optionPrice_KO_CL=zeros(1,length(F0));
        for i=1:length(F0)
            % Closed formula

            % Calls for bear spread
            call1 = EuropeanOptionClosed(F0(i),K,B,T,sigma,1);
            call2 = EuropeanOptionClosed(F0(i),KO,B,T,sigma,1);

            % Digital option
            d2=log(F0(i)/KO)/sigma/sqrt(T)-0.5*sigma*sqrt(T);
            DigitalOptionPrice=(KO-K)*B*normcdf(d2,0,1); %cdf('normal',d2,0,1) più lenta %% discount makes sense but check again

            % Closed price
            optionPrice_KO_CL(1,i)= call1-call2-DigitalOptionPrice;

            %optionPrice_KO_CL(1,i) = EuropeanOptionKOCL(F0(i),K, KO,B,T,sigma,N);
        end

        % Computing the second derivative numerically
        deltaF = (F0(2) - F0(1));
        h2 = deltaF^2;
        gamma = (optionPrice_KO_CL(1:end-2)-2*optionPrice_KO_CL(2:end-1)+optionPrice_KO_CL(3:end))./h2;

    case 4
        %gamma=GammaKOClosed(F0,K, KO,B,T,sigma);
        % Computing d1 - EU option with strike K
        d1_K = log(F0/K)/(sigma*sqrt(T))+0.5*sigma*sqrt(T);

        % Computing d1 - EU option with strike K
        d1_KO = log(F0/KO)/(sigma*sqrt(T))+0.5*sigma*sqrt(T);

        % Computing d2 - used for the digital option
        d2 = log(F0/KO)/(sigma*sqrt(T))-0.5*sigma*sqrt(T);

        % Computing gamma of the bear spread:
        GammaBearSpd = pdf('normal',d1_K,0,1)./(F0*sigma*sqrt(T)) - pdf('normal',d1_KO,0,1)./(F0*sigma*sqrt(T));

        % Gamma for the digital Option
        GammaDG = (KO-K)*pdf('normal',d2,0,1)./((F0.^2)*sigma*sqrt(T)).*(-d2/(sigma*sqrt(T))-1);

        gamma = GammaBearSpd - GammaDG;
        
    otherwise
end
end