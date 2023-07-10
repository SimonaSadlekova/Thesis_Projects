function [optX, optF] = VNDMOLZ3Pareto(nOptList, nParts, order)
%% VNDMOLZ3Fitness
% This function defines VND modification of LZ3 problem defined
% in:
% LI, Hui; ZHANG, Qingfu. Multiobjective optimization problems
% with complicated Pareto sets, MOEA/D and NSGA-II. IEEE Transactions on
% evolutionary computation, 2009, 13.2: 284-302.

% Included in FOPS, info@antennatoolbox.com
% (c) 2019, Martin Marek, BUT, martin.marek@antennatoolbox.com
N = 10000;
nVars = max(nOptList);
j1 = 3:2:nVars;
j2 = 2:2:nVars;
x(:, 1) = linspace(0, 1, N);
x1 = x(:, 1);
tempF1 = (0.8 * x1)*ones(1, length(j1)) .* cos((6*pi()*x1)*ones(1, length(j1)) + ones(N, 1)*((j1*pi())/nVars));
tempF2 = (0.8 * x1)*ones(1, length(j2)) .* sin((6*pi()*x1)*ones(1, length(j2)) + ones(N, 1)*((j2*pi())/nVars));
x(:, j1) = tempF1;
x(:, j2) = tempF2;
fitness = @(x)VNDMOLZ3Fitness(x, nOptList, nParts, order);
[~, optN] = fitness(x);
tempX = cell(N, 1);
tempF = zeros(N, 2);
for iS = 1:N
   actNVars = optN(iS);
   actX = zeros(1, actNVars);
   actX(1) = x(iS, 1);
   j1 = 3:2:actNVars;
   j2 = 2:2:actNVars;
   x1 = x(iS, 1);
   tempF1 = 0.8 * x1 .* cos(6*pi()*x1 + ((j1*pi())/actNVars));
   tempF2 = 0.8 * x1 .* sin(6*pi()*x1 + ((j2*pi())/actNVars));
   actX(:, j1) = tempF1;
   actX(:, j2) = tempF2;
   tempX{iS} = actX;
   tempF(iS, :) = fitness(tempX{iS});
end
optX = tempX;
optF = tempF;
end
