# pricing of European Call Options using various numerical techniques
European Call Option pricing via CRR tree, MC
"This repository focuses on the pricing of European Call Options using various numerical techniques. The primary objectives are:

a. Price the option with an underlying price of 1 Euro (i.e., a derivative notional of 1 million Euros) using three different methods:
   i) Utilizing the 'blkprice' MATLAB function.
   ii) Employing a Cox-Ross-Rubinstein (CRR) tree approach.
   iii) Implementing a Monte-Carlo (MC) approach.

b. Investigate the choice of parameters for CRR and MC:
   - For CRR, examine the impact of setting M (number of intervals) to 100.
   - For MC, assess the effect of using M (number of simulations) equal to 1,000,000. Consider adequacy based on error metrics: absolute difference from the exact value for CRR and unbiased standard deviation of MC price.

d. Price a European Call Option with a European barrier at €1.1 (up&in) using both tree and MC techniques. Explore the existence of a closed formula and compare the results.

e. For the barrier option, plot the Gamma, potentially using both closed-form and numerical estimates, across a range of underlying prices from 0.70 Euro to 1.35 Euro. Analyze and comment on the results.

f. [Optional] Investigate the reduction of MC error using the antithetic variables technique (Hull 2009, Ch.19.7). Consider the relevance of option bid/ask prices in determining the required numerical precision.

c. Demonstrate how numerical errors for a call option rescale with M:
   - For CRR, show that the error scales as 1/M.
   - For MC, show that the error scales as 1/√M.

This repository provides a comprehensive exploration of option pricing methods, error analysis, and comparative insights for quantitative finance enthusiasts and practitioners."
