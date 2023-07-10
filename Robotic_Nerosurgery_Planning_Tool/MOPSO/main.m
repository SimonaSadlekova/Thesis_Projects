clc;
clear;
close all; 
%% Problem Definition

probName = 'VNDMOZDT2Fitness';

% in case: 'VNDMOLI1Fitness' and 'VNDMOLI2Fitness'
% % nVarsList = 2:20;
% % nOptList = 5:15;
% % nParts = 1;
% % order = false(1, nParts);
% % problem = getProblem(probName, nOptList, nMax); 

% in case: other objective problems
nOptList = 4:7;         % list of optimal dimensions
nVarsList = 3:30;       % list of all dimensions
nMax = max(nVarsList);  % max of nVars
nParts = 2;             % number of parts on Pareto-front
order = [false,true];  % increasing/decreasing of dimensionality
problem = getProblem(probName, nOptList, nVarsList, nParts, order);

%% Parameters of PSO

params.MaxIter = 100;          % Maximum Number of Iterations

params.PopSize = 1000;         % Population Size

params.w = 1;                  % Inertia Coefficient
params.wdamp = 0.99;           % Damping Ratio of Inertia Coefficient
params.c1 = 2;                 % Personal Accelaration Coefficient
params.c2 = 2;                 % Global Accelaration Coefficient
params.ShowIterInfo = false;   % Show Information about iteration
params.Boundary = 'absorbing';
params.nVarsList = nVarsList;
% params.nOptList = nOptList;
p3 = 0.99;
p1 = (1 - p3)/2;
p2 = (1 - p3)/2;
params.dimProbabilities = [p1 p2 p3];  % [p(GBEST) p(PBEST) p(particle)]

%% Calling PSO

out = VNDMOPSO(problem, params);

nPareto = size(out.exArchive, 2);
paretoFront = zeros(nPareto, size(out.exArchive(1).Density, 2));
for iS = 1:nPareto
    paretoFront(iS, :) = out.exArchive(iS).Density;
end

%% Optimal Pareto Front

% Included in FOPS, info@antennatoolbox.com
% (c) 2018, Martin Marek, BUT, martin.marek@antennatoolbox.com

% [optX, optF] = VNDMOLI2Pareto(nOptList', nMax);
[optX, optF] = VNDMOZDT2Pareto(nOptList', nParts, order);

optD = @(f) getNOpt(f, nOptList, nParts, order);
% fitness = @(x)VNDMOLI2Fitness(x, nOptList, nMax);
fitness  = @(x) VNDMOZDT2Fitness(x, nOptList, nParts, order);
optimalProblem = struct('limits', problem.Limits, 'fitness', fitness,...
    'fullControl', false, 'isVectorized', false, 'name', probName,...
    'nVarsList', nVarsList, 'optimalPosition', {optX}, 'optimalFitness',...
    optF, 'optimalDimension', optD, 'reference', [11,11], 'HVPF', 128.7781161);

%% Results

% plotting the results of a two-objective problem
fig = figure;
plot(paretoFront(:,1), paretoFront(:,2), 'rx')
xlabel('$f_1\,\mathrm{[-]}$', 'Interpreter', 'latex')
ylabel('$f_2\,\mathrm{[-]}$', 'Interpreter', 'latex')
hold on
plot(optimalProblem.optimalFitness(:,1), optimalProblem.optimalFitness(:,2), 'k-')
legend('Found PF','True PF')
% saveas(fig, probName,'epsc')

% % plotting the results of a three-objective problem
% fig = figure;
% plot3(paretoFront(:,1), paretoFront(:,2), paretoFront(:,3), 'rx')
% xlabel('$f_1\,\mathrm{[-]}$', 'Interpreter', 'latex')
% ylabel('$f_2\,\mathrm{[-]}$', 'Interpreter', 'latex')
% zlabel('$f_3\,\mathrm{[-]}$', 'Interpreter', 'latex')
% % title('VND-MOPSO on VNDMOUF10Fitness; MaxIter = 500; PopSize = 1000')
% % saveas(fig, probName,'epsc')

%% Metrics

GD = genDist(paretoFront, optimalProblem.optimalFitness);
SP = spread(paretoFront, optimalProblem.optimalFitness);
HV = hypervolume(paretoFront, optimalProblem.optimalFitness);
