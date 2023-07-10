clear all;
close all;
clc;
%% compareResults compares the results from two runs of the algorithm
% This script is able to compare the results from two runs of the VNDMOPSO
% optimization algorithm. The result is a combined Pareto-front from 
% the best solutions of both found sets, which is also finally plotted 
% in the figure. 
% The script can also be used to compare VND and FND version of the MOPSO 
% algorithm.

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

%% Files Loading

iName = 1;  % Number of polygon
polygonName = 'P1';
Boundary = 'absorbing_wall';
figName = 'comparePFtest_3plots';

paretoFront1 = load(['Polygons\' polygonName '\' Boundary '\PFtest_1.mat']);
paretoFront2 = load(['Polygons\' polygonName '\' Boundary '\PFtest_2.mat']);

% In the case of comparing VND and FND versions of the algorithm
% % paretoFront1 = load(['statisticTest\' polygonName '\PF_comb.mat']);
% % paretoFront2 = load(['Polygons\' polygonName '\' Boundary '\bestPF.mat']);

    %% Combining PF1 and PF2

    if isfield(paretoFront1, 'radius')
        newParetoFront.fitness = [paretoFront1.paretoFront; ...
            paretoFront2.paretoFront];
        newParetoFront.radius = [paretoFront1.radius; ...
            paretoFront2.radius];
        newParetoFront.centers_x = [paretoFront1.centers_x; ...
            paretoFront2.centers_x];
        newParetoFront.centers_y = [paretoFront1.centers_y; ...
            paretoFront2.centers_y];
    else
        paretoFront1.paretoFront = paretoFront1.combPF;
        paretoFront2.paretoFront = paretoFront2.bestPF.fitness;
        newParetoFront.fitness = [paretoFront1.paretoFront; ...
            paretoFront2.paretoFront];
    end
    %% Selection of Non-dominated Solutions

    newNonDomSolutions = kungEtAl(newParetoFront.fitness);

    %% Create an external archive
    if isfield(paretoFront1, 'radius')
        newExternalArchive.fitness = zeros(size(newNonDomSolutions,1), 2);
        newExternalArchive.radius = cell(size(newNonDomSolutions,1) ,1);
        newExternalArchive.centers_x = cell(size(newNonDomSolutions,1) ,1);
        newExternalArchive.centers_y = cell(size(newNonDomSolutions,1) ,1);
    
        for iND = 1:numel(newNonDomSolutions)
            newExternalArchive.fitness(iND,:) = ...
                newParetoFront.fitness(newNonDomSolutions(iND),:);
            newExternalArchive.radius{iND} = ...
                newParetoFront.radius{newNonDomSolutions(iND)};
            newExternalArchive.centers_x{iND} = ...
                newParetoFront.centers_x{newNonDomSolutions(iND)};
            newExternalArchive.centers_y{iND} = ...
                newParetoFront.centers_y{newNonDomSolutions(iND)};
        end
    else
        newExternalArchive.fitness = zeros(size(newNonDomSolutions,1), 2);

        for iND = 1:numel(newNonDomSolutions)
            newExternalArchive.fitness(iND,:) = ...
                newParetoFront.fitness(newNonDomSolutions(iND),:);
        end
    end
    %% Number of solutions from PF1 and PF2 in the external archive
    
    PF1 = sum(newNonDomSolutions(:,1) < size(paretoFront1.paretoFront,1)+1);
    PF2 = sum(newNonDomSolutions(:,1) > size(paretoFront1.paretoFront,1));

    %% The best non-dominated solutions from both sets

    if isfield(paretoFront1, 'radius')
        bestPF.fitness = newExternalArchive.fitness;
        bestPF.radius = newExternalArchive.radius;
        bestPF.x = newExternalArchive.centers_x;
        bestPF.y = newExternalArchive.centers_y;
        save(['Polygons\' polygonName '\' ...
            Boundary '\bestPFe.mat'], 'bestPF')
    else

    %% Comparison of algorithms with fixed dimensions and VND and results

        if PF1 > PF2
            bestPF.fitness = paretoFront1.paretoFront;
            save(['combPolCompare\' polygonName '\' ...
                Boundary '\bestPF_fixed.mat'], 'bestPF')
        elseif PF1 < PF2
            bestPF.fitness = paretoFront2.paretoFront;
            save(['combPolCompare\' polygonName '\' ...
                Boundary '\bestPF_VND.mat'], 'bestPF')
        else           
            bestPF.fitness = newParetoFront.fitness;            
            save(['combPolCompare\' polygonName '\' ...
                Boundary '\bestPF_equal.mat'], 'bestPF')
        end
    end

    %% Plot compared figure

    fig = figure
    set(gcf, 'Position', get(0, 'Screensize'));

    t1 = annotation('textbox', 'Position', [0.46 0.9, 0.10 0.1], ...
        'String', (['Polygon ' num2str(iName)]), 'EdgeColor', ...
        [0.9400 0.9400 0.9400], 'FontSize', 25, 'FontWeight', 'bold');

    pos1 = [0.05 0.2 0.27 0.65];
    subplot('Position', pos1)    
    plot(paretoFront1.paretoFront(:,1), paretoFront1.paretoFront(:,2), 'kx')
%     subtitle('Fixed Setting of Dimensions', 'FontSize', 13, 'FontWeight', 'bold')
    subtitle('Pareto front 1', 'FontSize', 13, 'FontWeight', 'bold')
    xlabel('Remaining area', 'Interpreter', 'latex')
    ylabel('(Overlapping + out of polygon) area', 'Interpreter', 'latex')
    hold on
    plot(newExternalArchive.fitness(1:PF1,1), ... 
        newExternalArchive.fitness(1:PF1,2), 'bx', ...
        'MarkerSize', 7, 'LineWidth', 1.3)

    pos2 = [0.71 0.2 0.27 0.65];
    subplot('Position', pos2)
    plot(paretoFront2.paretoFront(:,1), paretoFront2.paretoFront(:,2), 'kx')
%     subtitle('VNDMOPSO Algorithm', 'FontSize', 13, 'FontWeight', 'bold')
    subtitle('Pareto front 2', 'FontSize', 13, 'FontWeight', 'bold')
    xlabel('Remaining area', 'Interpreter', 'latex')
    ylabel('(Overlapping + out of polygon) area', 'Interpreter', 'latex')
    hold on
    plot(newExternalArchive.fitness(PF1+1:end,1), ...
        newExternalArchive.fitness(PF1+1:end,2), 'rx',...
        'MarkerSize', 7, 'LineWidth', 1.3)
    
    pos3 = [0.38 0.2 0.27 0.65];
    subplot('Position', pos3)
    plot(newExternalArchive.fitness(1:PF1,1), ...
        newExternalArchive.fitness(1:PF1,2), 'bx',...
        'MarkerSize', 7, 'LineWidth', 1.3)
    hold on
    plot(newExternalArchive.fitness(PF1+1:end,1), ...
        newExternalArchive.fitness(PF1+1:end,2), 'rx',...
        'MarkerSize', 7, 'LineWidth', 1.3)
    subtitle('Combined Pareto Front', 'FontSize', 13, 'FontWeight', 'bold')
    xlabel('Remaining area', 'Interpreter', 'latex')
    ylabel('(Overlapping + out of polygon) area', 'Interpreter', 'latex')
%     legend(['Fixed Dimensions: ' num2str(PF1)], ['VNDMOPSO Algorithm: ' num2str(PF2)])
    legend(['PF_1: ' num2str(PF1)], ['PF_2: ' num2str(PF2)])
    
    saveas(fig, ['Polygons\' polygonName '\' Boundary '\' figName '.png']);
%     saveas(fig, ['Polygons\' polygonName '\' Boundary '\' figName '.eps']);
