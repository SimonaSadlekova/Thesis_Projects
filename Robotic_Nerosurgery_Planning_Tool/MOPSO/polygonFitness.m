function fitness = polygonFitness(x, polygon)
%% polygonFitness calculates the remaining, overlapping area and 
%% the area outside another area
% This function calculates the area of a polygon not covered by 
% ablation objects, the overlapping area of ablation objects, 
% and the area of ablation objects protruding from the polygon

% INPUTS
% x: vector of randomly generated numbers bounded by limits, ...
% matrix[1 x particle(i).Dimension]
% polygon: defines a polygon, struct[1 x 1]

% OUTPUTS
% fitness: values of fitness functions, matrix[1 x 2]

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

nCircles = size(x, 2)/3;

% random points 
nP = 10000;

points = [polygon.bBox(1,1) + (polygon.bBox(2,1) - polygon.bBox(1,1))*rand(nP, 1), ...
   polygon.bBox(1,2) + (polygon.bBox(2,2) - polygon.bBox(1,2))*rand(nP, 1)];

% Calling the function to find out which points lie inside the polygon
areInPolygon = arePointsInPolygon(points, polygon.points, 1e-10);

nInPolygon = sum(areInPolygon);

% Calculation of tumor area
areaPolygon = nInPolygon/nP;

r = x(3:3:end);
centers(:,1) = x(1:3:end-2);
centers(:,2) = x(2:3:end-1);

% Distances between centers and points
ED_CP = euclideanDistanceBetweenTwoSets(centers, points);

%% Covered area
for iD = 1:nCircles
    for iP = 1:nP
        if (ED_CP(iD,iP) < r(iD)) && areInPolygon(iP) == true
            areInCircle(iD,iP) = true;
            areInCircleOutOfTumor(iD,iP) = false;
        elseif (ED_CP(iD,iP) < r(iD)) && areInPolygon(iP) == false
            areInCircleOutOfTumor(iD,iP) = true;
            areInCircle(iD,iP) = false;
        else
            areInCircle(iD,iP) = false;
            areInCircleOutOfTumor(iD,iP) = false;
        end
    end
end
bBoxArea = (polygon.bBox(2,1)*polygon.bBox(2,2));

%% area covered in tumor
nInTumor = sum(any(areInCircle));
areaCovered = nInTumor/nP*bBoxArea;

% Remaining area
areaRemaining = areaPolygon*bBoxArea - areaCovered;

%% Overlapping area
nOver = sum(sum(areInCircle) > 1);
areaOverlap = nOver/nP*bBoxArea;

%% area out of polygon 
nOutTumor = sum(any(areInCircleOutOfTumor));
areaOutOfPoly = nOutTumor/nP*bBoxArea;

%% fitness
fitness(1, 1) = areaRemaining;
fitness(1, 2) = areaOverlap + areaOutOfPoly;

end