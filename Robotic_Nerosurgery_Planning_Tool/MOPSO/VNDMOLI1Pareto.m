function [optX, optF] = VNDMOLI1Pareto(nOptList, nMax)
%% VNDMOLI1Pareto
% This function defines VND problem defined in:
% LI, Hui; DEB, Kalyanmoy. Challenges for evolutionary multiobjective
% optimization algorithms in solving variable-length problems.
% In: Evolutionary Computation (CEC), 2017 IEEE Congress on.
% IEEE, 2017. p. 2217-2224.

% Included in FOPS, info@antennatoolbox.com
% (c) 2018, Martin Marek, BUT, martin.marek@antennatoolbox.com
N = 10000;
nParts = 1;
order = false;
x1 = linspace(0, 1, N);
tempF(:, 1) = x1;
tempF(:, 2) = 1-x1;
optN = getNOpt(tempF, nOptList, nParts, order)';
fitness = @(x)VNDMOLI1Fitness(x, nOptList, nMax);
xj = sin(optN / (2*nMax)*pi);
x = cell(N, 1);
f = zeros(N, 2);
for iS = 1:N
   x{iS} = [x1(iS), repmat(xj(iS), 1, optN(iS)-1)];
   f(iS, :) = fitness(x{iS});
end
optX = x;
optF = f;
% plot(f(:, 1), f(:, 2), '.')
% position = x;
% fitness = f;
% save('VNDMOLI1', 'position', 'fitness')
end