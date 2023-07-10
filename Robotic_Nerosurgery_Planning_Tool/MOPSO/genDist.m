function GD = genDist(paretoFront, trueParetoFront) 
%% genDist function - applies the Generetional Distance Metric
% This function compares the position of the found Pareto front with the
% position of the true one by calculation of the Euclidean distance between 
% their members.

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

PF = size(paretoFront, 1); % found solutions

% Calculate Euclidean Distance
ED = zeros(PF, 1);
for iED = 1:PF
    ED(iED) = min(sqrt(sum(( ...
       repmat(paretoFront(iED, :), size(trueParetoFront, 1), 1) - ...
       trueParetoFront).^2, 2)));
end

% Calculate Generational Distance
GD = sum(ED)./PF;

end