function distMatrix = euclideanDistanceBetweenTwoSets(set1, set2)
%% euclideanDistanceBetweenTwoSets compute distance between two sets of points 
% This function computes Euclidean distance between two sets of points.
%
%  INPUTS
%   set1: first set of points, double [nPoints x nDims]
%   set2: second set of points, double [mPoints x nDims]
% 
%  OUTPUTS
%   distMatrix: distance between points, double [nPoints x mPoints]
% 
%  SYNTAX
%  
%  distMatrix = models.utilities.geomPublic. ...
% euclideanDistanceBetweenTwoSets(set1, set2)
% 
% Function euclideanDistanceBetweenTwoSets computes pairwise distances between 
% two sets of points defined in _set1_ and _set2_.
%
% Included in AToM, info@antennatoolbox.com
% © 2015, Petr Kadlec, BUT, petr.kadlec@antennatoolbox.com
% © 2016, Vladimir Sedenka, BUT, vladimir.sedenka@antennatoolbox.com
% mcode

distMatrix = sqrt(bsxfun(...
   @plus, dot(set1, set1, 2), dot(set2, set2, 2)') - 2*(set1*set2'));

end

