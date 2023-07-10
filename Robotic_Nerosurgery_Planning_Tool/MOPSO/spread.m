function SP = spread(paretoFront, trueParetoFront) 
%% spread function - applies the Spread Metric
% This metric evaluates the allocation of the members of the found 
% set of non-dominated solutions along the Pareto front based on 
% the mutual Euclidean distance and the distance of the extremes 
% of the found front from the extremes of the true front.

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

PF = size(paretoFront, 1); % found solutions
paretoFront = sortrows(paretoFront);

% Calculate Euclidean Distances
for iED = 2:PF
    ED(iED) = sqrt(sum((paretoFront(iED, :) - paretoFront(iED-1, :)).^2));
end

try
D = mean(ED);
catch ex
    keyboard
end

extreme1 = [max(paretoFront(:,2)), min(paretoFront(:,1))];
extreme2 = [min(paretoFront(:,2)), max(paretoFront(:,1))];
trueExtreme1 = [max(trueParetoFront(:,2)), min(trueParetoFront(:,1))];
trueExtreme2 = [min(trueParetoFront(:,2)), max(trueParetoFront(:,1))];

dme1 = sqrt(sum(extreme1(1,:) - trueExtreme1(1,:)).^2);
dme2 = sqrt(sum(extreme2(1,:) - trueExtreme2(1,:)).^2);

SP = (dme1 + dme2 + sum(abs(ED - D)))./(dme1 + dme2 + sum(PF.* D));

end