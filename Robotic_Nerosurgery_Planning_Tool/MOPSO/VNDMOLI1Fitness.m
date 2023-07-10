function [fitness, optN] = VNDMOLI1Fitness(x, nOptList, nMax)
%% VNDMOLI1Fitness
% This function defines VND problem defined in:
% LI, Hui; DEB, Kalyanmoy. Challenges for evolutionary multiobjective
% optimization algorithms in solving variable-length problems.
% In: Evolutionary Computation (CEC), 2017 IEEE Congress on.
% IEEE, 2017. p. 2217-2224.

% Included in FOPS, info@antennatoolbox.com
% (c) 2018, Martin Marek, BUT, martin.marek@antennatoolbox.com
nVars = size(x, 2);
nParts = 1;
order = false;

f(:, 1) = x(:, 1);
f(:, 2) = 1-x(:, 1);
optN = getNOpt(f, nOptList, nParts, order)';
g1 = sum(x(:, 2:end)-sin(optN./(2*nMax)*pi), 2).^2;

VNDpenalization = 0.01*(nVars - optN).^2;
fitness(:, 1) = f(:, 1) + g1;
fitness(:, 2) = f(:, 2) + g1 + VNDpenalization;
end

