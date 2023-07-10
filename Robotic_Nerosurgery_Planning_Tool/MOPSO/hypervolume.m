function HV = hypervolume(paretoFront, trueParetoFront) 
%% hypervolume function - applies the Hypervolume Metric
% The function calculates the volume of the space bounded by 
% the members of the found Pareto front and the reference point.

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

PF = size(paretoFront, 1);
paretoFront = sortrows(paretoFront);

% Reference Point
refPoint = [max(trueParetoFront(:,1)), max(trueParetoFront(:,2))];

hypercube = zeros(PF, 1);

% Calculation of individual hypercubes
for i = 1:PF-1
distanceA = paretoFront(i+1,1) - (paretoFront(i,1));
distanceB = refPoint(2) - (paretoFront(i,2));
hypercube(i) = distanceA .* distanceB;
end

distanceA = refPoint(1) - (paretoFront(i+1,1));
distanceB = refPoint(2) - (paretoFront(i+1,2));
hypercube(i+1) = distanceA .* distanceB;

% Calculation of the hypervolume created by uniting individual hypercubes
HV = sum(hypercube);

end