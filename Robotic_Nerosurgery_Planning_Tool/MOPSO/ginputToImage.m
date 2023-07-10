clear all
close all
clc
%% ginputToImage defines a shape from an image
% The user defines a shape on the image, then confirms (Enter) and 
% the defined shape is then saved in the selected folder as a *.mat file. 
% Finally, the shape is plotted and the figure is saved.

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

% Display a file
Name = 'P11';
I = imread('fig02.jpg');
figure
imshow(I)

% selection of tumor shape 
[x,y] = ginput();
y = -y;
polygon = [x,y];

pSorted = sort(polygon);
dlt = max(pSorted(end, :) - pSorted(1, :));
polygon = [polygon(:,1)-pSorted(1,1), polygon(:,2)-pSorted(1,2)]/dlt;

% Save and plot
save('P11.mat','polygon')
fig = figure;
plot(polygon(:,1),polygon(:,2),'r')
% saveas(fig, Name,'epsc')
saveas(fig, Name,'jpg')
