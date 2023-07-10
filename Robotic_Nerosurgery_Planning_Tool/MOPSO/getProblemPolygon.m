function problem = getProblemPolygon(str)
%% getProblemPolygon returns a structure containing the properties of the selected problem
% Using this function, a specific problem can be selected.

% INPUTS
%   str: struct [1 x 1]

% OUTPUTS 
%   problem structure, struct [1 x 1]

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

switch str.name 
    case 'VNDMOLI1Fitness'
        nMax = max(nVars); % maximum number of dimensions, double [1 x 1]
        problem.DensityFunction = @(x) VNDMOLI1Fitness(x, nOpt, nVars); % fitness function
        problem.Limits = [zeros(1, nMax); ones(1, nMax)]; % Lower and Upper Bound Limits
    case 'VNDMOLI2Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOLI2Fitness(x, nOpt, nVars);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMODTLZ4Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMODTLZ4Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)]; 
    case 'VNDMODTLZ7Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMODTLZ7Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMOLZ3Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOLZ3Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMOLZ6Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOLZ6Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMOUF5Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOUF5Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMOUF10Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOUF10Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMOZDT2Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOZDT2Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMOZDT3Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOZDT3Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'VNDMOUF6Fitness'
        nMax = max(nVars);
        problem.DensityFunction = @(x) VNDMOUF6Fitness(x, nOpt, nParts, order);
        problem.Limits = [zeros(1, nMax); ones(1, nMax)];
    case 'polygon'
        nMax = max(str.nVarsList);
        problem.DensityFunction = @(x, y) polygonFitness(x,y);
        problem.Limits = [repmat([0.3 0.3 0.05], 1, nMax/3); repmat([0.7 0.7 0.4], 1, nMax/3)];
        problem.polygon = str.polygon;      
end
