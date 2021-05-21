function pw = Weibull(V0,C,k)

% Compute Weibull probability density function
% 
% ACCORDING TO IEC61400-1 Ed.2
% Cumulative probability function, i.e. the probability that V<V0 is
% Pw(V0) = 1 - exp(-(V0/C)^k)
% Differentianting the distribution functions yields the corresponding probaility density function:
% pw(V0) = k*V0^(k-1)/C^k * exp(-(V0/C)^k)
%
% where:
%
% C = scale parameter of the Weibull function
% k = shape parameters of the Weibull function
%
% Rayleight function is identical to Weibull function when k=2 and Vave = C*sqrt(pi)/2:
% Pr(V0) = 1 - exp(-pi(V0/2*Vave)^2)
%
% ALEALE 10 December 2009

pw = k*V0.^(k-1)/C^k .* exp(-(V0./C).^k);

return
