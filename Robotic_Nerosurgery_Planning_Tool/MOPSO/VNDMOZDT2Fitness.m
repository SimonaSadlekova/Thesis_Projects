function [fitness, optN] = VNDMOZDT2Fitness(x, nOptList, nParts, order)
%% VNDMOZDT2Fitness
% This function defines VND modified ZDT2 study.
% More info in: DEB, Kalyanmoy. An introduction to genetic algorithms.
% Sadhana, 1999, 24.4-5: 293-315.

% Included in FOPS, info@antennatoolbox.com
% (c) 2018, Martin Marek, BUT, martin.marek@antennatoolbox.com
nVars = size(x, 2);
g = 1 + 9*sum(x(:, 2:nVars), 2)/(nVars-1);
f(:, 1) = x(:, 1);
f(:, 2) = g .* (1-(x(:, 1)./g).^2);

optN = getNOpt(f, nOptList, nParts, order);

VNDpenalization = 0.1*(nVars - optN).^2;
fitness(:, 1) = f(:, 1);
fitness(:, 2) = f(:, 2) + VNDpenalization;
end