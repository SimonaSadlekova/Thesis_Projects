function [optX, optF] = VNDMOZDT2Pareto(nOptList, nParts, order)
%% VNDMOZDT2Fitness
% This function defines VND modified ZDT2 study.
% More info in: DEB, Kalyanmoy. An introduction to genetic algorithms.
% Sadhana, 1999, 24.4-5: 293-315.

% Included in FOPS, info@antennatoolbox.com
% (c) 2018, Martin Marek, BUT, martin.marek@antennatoolbox.com
N = 10000;
x = zeros(N, max(nOptList));
x(:, 1) = linspace(0, 1, N);
fitness = @(x)VNDMOZDT2Fitness(x, nOptList, nParts, order);
[~, optN] = fitness(x);
tempX = cell(N, 1);
tempF = zeros(N, 2);
for iS = 1:N
   tempX{iS} = x(iS, 1:optN(iS));
   tempF(iS, :) = fitness(tempX{iS});
end
optX = tempX;
optF = tempF;
% plot(tempF(:, 1), tempF(:, 2), '.')
% position = tempX;
% fitness = tempF;
% save('VNDMOZDT2', 'position', 'fitness')
end