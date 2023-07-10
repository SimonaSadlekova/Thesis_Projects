function [fitness, optN] = VNDMOLZ3Fitness(x, nOptList, nParts, order)
%% VNDMOLZ3Fitness
% This function defines VND modification of LZ3 problem defined
% in:
% LI, Hui; ZHANG, Qingfu. Multiobjective optimization problems
% with complicated Pareto sets, MOEA/D and NSGA-II. IEEE Transactions on
% evolutionary computation, 2009, 13.2: 284-302.

% Included in FOPS, info@antennatoolbox.com
% (c) 2019, Martin Marek, BUT, martin.marek@antennatoolbox.com
[N,nVars] = size(x);
j1 = 3:2:nVars;
J1 = x(:, j1);
j2 = 2:2:nVars;
J2 = x(:, j2);
x1 = x(:, 1);
tempF1 = (0.8 * x1)*ones(1, length(j1)) .* cos((6*pi()*x1)*ones(1, length(j1)) + ones(N, 1)*((j1*pi())/nVars));
tempF2 = (0.8 * x1)*ones(1, length(j2)) .* sin((6*pi()*x1)*ones(1, length(j2)) + ones(N, 1)*((j2*pi())/nVars));
f(:, 1) = x1 + (2/numel(j1)) * sum((J1-tempF1).^2, 2);
f(:, 2) = 1 - sqrt(x1) + (2/numel(j2)) * sum((J2-tempF2).^2, 2);

optN = getNOpt(f, nOptList, nParts, order);
VNDpenalization = 0.06*(nVars - optN).^2;

fitness(:, 1) = f(:, 1);
fitness(:, 2) = f(:, 2) + VNDpenalization;
end