clc;
clear;
close all; 
%% Problem Definition

polygonName = 'P1';

str.name = 'polygon';

str.nVarsList = 3:3:30;     % list of all dimensions
nMax = max(str.nVarsList);  % max of nVars
load(['..\3DObjects\' polygonName '.mat'])
polyStr.points = polygon;

% find bBox
pSorted = sort(polygon);
lower = pSorted(1, :);
upper = pSorted(end, :);

polyStr.bBox = [lower; upper];
str.polygon = polyStr;

% Problem Selection
problem = getProblemPolygon(str);

%% Parameters of PSO

params.MaxIter = 100;          % Maximum Number of Iterations

params.PopSize = 300;          % Population Size

params.w = 1;                  % Inertia Coefficient
params.wdamp = 0.99;           % Damping Ratio of Inertia Coefficient
params.c1 = 2;                 % Personal Accelaration Coefficient
params.c2 = 2;                 % Global Accelaration Coefficient
params.ShowIterInfo = false;   % Show Information about iteration
params.Boundary = 'absorbing';
params.nVarsList = str.nVarsList;
p3 = 0.99;
p1 = (1 - p3)/2;
p2 = (1 - p3)/2;
params.dimProbabilities = [p1 p2 p3];  % [p(GBEST) p(PBEST) p(particle)]

%% Calling PSO

for i = 1:2

    out = VNDMOPSO(problem, params);

    nPareto = size(out.exArchive, 2);

    paretoFront = zeros(nPareto, size(out.exArchive(1).Density, 2));
    radius = cell(nPareto, 1);
    centers_x = cell(nPareto, 1);
    centers_y = cell(nPareto, 1);
    for iS = 1:nPareto
        paretoFront(iS, :) = out.exArchive(iS).Density;
        radius{iS} = out.exArchive(iS).Position(3:3:end);
        centers_x{iS} = out.exArchive(iS).Position(1:3:end-2);
        centers_y{iS} = out.exArchive(iS).Position(2:3:end-1);
    end

%% Results

    % plotting the results of a problem
    fig = figure;
    plot(paretoFront(:,1), paretoFront(:,2), 'rx')
    xlabel('Remaining area', 'Interpreter', 'latex')
    ylabel('(Overlapping + out of polygon) area', 'Interpreter', 'latex')
    
    % save results
    if i == 1
        save(['Polygons\' polygonName '\' params.Boundary '_wall\ ...' ...
            'PFtest_1.mat'], 'paretoFront', 'radius', 'centers_x', 'centers_y')
%         saveas(fig, ['Polygons\' polygonName '\' params.Boundary '_wall\PFtest_1.png'])
    else
        save(['Polygons\' polygonName '\' params.Boundary '_wall\ ...' ...
            'PFtest_2.mat'], 'paretoFront', 'radius', 'centers_x', 'centers_y')
%         saveas(fig, ['Polygons\' polygonName '\' params.Boundary '_wall\PFtest_2.png'])
    end

end
