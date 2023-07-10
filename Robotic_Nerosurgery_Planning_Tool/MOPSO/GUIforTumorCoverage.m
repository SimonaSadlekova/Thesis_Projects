clear all;
close all;
clc;
%% GUIforTumorCoverage visualizes the optimization results
% This GUI is a tool for displaying the distribution of ablation objects
% (represented by blue circles) in the tumor area (represented by a red 
% polygon). After running, a workspace is displayed, in which the user can 
% select a specific point in the graph or an index in the roller (popupmenu). 
% Based on its selection, the corresponding distribution of ablation objects 
% in the area of the polygon is displayed in the right figure.

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

polygonName = 'P1';
Boundary = 'absorbing_wall';

% file that contains function values
bestPF = load(['Polygons\' polygonName '\' Boundary '\bestPF.mat']); 
PF = bestPF.bestPF.fitness;

% file that contains polygon points
polygon = load(['..\3DObjects\' polygonName '.mat']); 
polygon = polygon.polygon;

% list of indices
numberOfMembers = size(PF,1);
rolString = cell(numberOfMembers, 1);
for iN = 1:numberOfMembers
    rolString{iN} = iN;
end

fig = figure; % main figure
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf, 'InvertHardcopy', 'off');

%% At the beginning, the Pareto Front is plotted on the left and polygon on the right

subplot(1, 2, 1)
ax1 = gca;
ax1.Position = [0.0800 0.1100 0.3347 0.8150];
ax1.NextPlot = 'add';

% Plotting ParetoFront
for iN = 1:size(PF, 1)
   clickPlot(iN) = plot(ax1, PF(iN,1), PF(iN,2), 'kx', ...
      'ButtonDownFcn', @indexCallback);  
end

xlabel('Remaining area', 'Interpreter', 'latex')
ylabel('(Overlapping + out of polygon) area', 'Interpreter', 'latex')
title('The Set of Solutions Found by the Optimization Algorithm', ...
    'FontSize', 14)

subplot(1, 2, 2)
ax2 = gca;
ax2.Position = [0.6303 0.1100 0.3347 0.8150];

% Plotting a polygon
fill(ax2, polygon(:,1), polygon(:,2), 'r', 'LineWidth', 2, 'FaceAlpha',.3,'EdgeAlpha',.4)
axis equal
ylim(ax2,[-0.2 1.2])
title('Visualization of Tumor Coverage by Ablation Objects', 'FontSize', 14)
ax2.NextPlot = 'replacechildren';

t1 = annotation('textbox', 'Position', [0.44 0.45, 0.15 0.2], ...
    'EdgeColor', [0.9400 0.9400 0.9400], 'Interpreter', 'latex', ...
    'FontSize', 13);

t2 = annotation('textbox', 'Position', [0.46 0.3, 0.15 0.2], ...
    'EdgeColor', [0.9400 0.9400 0.9400], 'Interpreter', 'latex', ...
    'FontSize', 13);

uit = uitable('Parent', fig, 'Units', 'normalized', 'Data', {}, ...
    'Position', [0.45 0.2 0.1339 0.14], 'RowName', 'numbered', ... 
    'ColumnName', {'X', 'Y', 'Radius'}, 'FontSize', 9);

%% UIControl object

rol = uicontrol(fig, 'Style', 'popupmenu', ...
   'Units', 'normalized', ...
   'String', rolString, ...
   'Position', [0.49 0.89, 0.05 0.1], ....
   'Callback', @indexCallback);

setappdata(rol, 'leftAxis', ax1)
setappdata(ax1, 'rightAxis', ax2)
setappdata(ax1, 'bestPF', bestPF)
setappdata(ax1, 'remArea', t1)
setappdata(ax1, 'overArea', t2)
setappdata(ax1, 'polygon', polygon)
setappdata(ax1, 'table', uit)

%% Callback function

function indexCallback(obj, event)

persistent prev_plot1;

% Delete the previous plot <======= THIS TURNS BLACK THE LAST PLOT
if(~isempty(prev_plot1))
    delete(prev_plot1);
end

% Select the callback object
if isa(obj, 'matlab.graphics.chart.primitive.Line')
   axL = obj.Parent;
else
   axL = getappdata(obj, 'leftAxis');
end
bestPF = getappdata(axL, 'bestPF');
paretoFront = bestPF.bestPF.fitness;
if isa(obj, 'matlab.graphics.chart.primitive.Line')
   curPF = [obj.XData, obj.YData];
   ID = find(ismember(paretoFront, curPF, 'rows'));
   ID = ID(1);
else
   ID = obj.Value;
   curPF = paretoFront(ID,:);
end

% Marking the point that corresponds to the selected index
prev_plot1 = plot(axL, curPF(1, 1), curPF(1, 2),  'rx', ...
    'MarkerSize', 9, 'LineWidth', 2);

axR = getappdata(axL, 'rightAxis');

% Initialization of centers and radii of circles
for i = 1:size(paretoFront,1)
    circles(i).centers_x = bestPF.bestPF.x{i};
    circles(i).centers_y = bestPF.bestPF.y{i};
    circles(i).r = bestPF.bestPF.radius{i};
end
nCircles = size(circles(ID).r, 2);
a = linspace(0, 2*pi, 51);

% Plotting circles in polygon
polygon = getappdata(axL, 'polygon');
fill(axR, polygon(:,1), polygon(:,2), 'r', 'LineWidth', 2, ...
   'FaceAlpha',.3,'EdgeAlpha',.4)
axR.NextPlot = 'add';

for iD = 1:nCircles   
        fill(axR, circles(ID).centers_x(iD) + ...
        circles(ID).r(iD).*cos(a), circles(ID).centers_y(iD) + ...
        circles(ID).r(iD).*sin(a),'b', 'FaceAlpha',.2,'EdgeAlpha',.4);
end

axR.NextPlot = 'replacechildren';

% Print the percentage coverage/overlap area
sRem = getappdata(axL, 'remArea');
sRem.String = {['\bf{Remaining area = }' num2str(paretoFront(ID,1)*100) '\bf{\%}']};
sOver = getappdata(axL, 'overArea');
sOver.String = {['\bf{Overlap = }' num2str(paretoFront(ID,2)*100) '\bf{\%}']};

% Table with positions and radii of circles
table = getappdata(axL, 'table');
for iT = 1:nCircles
    Data(iT,:) = {circles(ID).centers_x(iT) circles(ID).centers_y(iT) circles(ID).r(iT)};
end
table.Data = Data;

end
