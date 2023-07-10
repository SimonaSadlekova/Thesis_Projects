function [areIn, onEdge] = arePointsInPolygon(points, polygon, tol)
%% http://www.inf.usi.ch/hormann/papers/Hormann.2001.TPI.pdf
% Algorithm 7
nPoints = size(points, 1);

nPoly = size(polygon, 1);
w = zeros(nPoints, 1);
areIn = false(nPoints, 1);
onEdge = areIn;
for iP = 1:nPoints
   arePointsSame = polygon(1, 1) == points(iP, 1) && ...
      polygon(1, 2) == points(iP, 2);   
   if arePointsSame
      areIn(iP) = true;
      onEdge(iP) = true;
      continue
   end
   
   for iPol = 1:nPoly-1
     isY2Same = polygon(iPol+1, 2) == points(iP, 2);
      if isY2Same
         isX2Same = polygon(iPol+1, 1) == points(iP, 1);
         if isX2Same
            areIn(iP) = true;
            onEdge(iP) = true;
            continue
         else
            isY1Same = polygon(iPol, 2) == points(iP, 2);
            horLineCrossed = (polygon(iPol+1, 1) > points(iP, 1)) == ...
               (polygon(iPol, 1) < points(iP, 1));
            if isY1Same && horLineCrossed
               areIn(iP) = true;
               onEdge(iP) = true;
               continue
            end
         end
      end
      
      crossing = (polygon(iPol, 2) < points(iP, 2)) ~= ...
         (polygon(iPol + 1, 2) < points(iP, 2));
      if crossing
         isX1GreaterOrEqual = polygon(iPol, 1) >= points(iP, 1);
         isX2Greater = polygon(iPol + 1, 1) > points(iP, 1);
         if isX1GreaterOrEqual
            if isX2Greater
               w(iP) = w(iP) + 2*(polygon(iPol + 1, 2) > ...
                  polygon(iPol, 2)) - 1;
            else
               detI = (polygon(iPol, 1) - points(iP, 1)) * ...
                  (polygon(iPol + 1, 2) - points(iP, 2)) - ...
                  (polygon(iPol + 1, 1) - points(iP, 1)) * ...
                  (polygon(iPol, 2) - points(iP, 2));
               if abs(detI) < tol
                  areIn(iP) = true;
                  onEdge(iP) = true;
                  continue
               end
               rightCrossing = (detI > 0) == ...
                  (polygon(iPol + 1, 2) > polygon(iPol, 2));
               if rightCrossing
                  w(iP) = w(iP) + ...
                     2*(polygon(iPol + 1, 2) > polygon(iPol, 2)) - 1;
               end
            end
         else
            if isX2Greater
               detI = (polygon(iPol, 1) - points(iP, 1)) * ...
                  (polygon(iPol + 1, 2) - points(iP, 2)) - ...
                  (polygon(iPol + 1, 1) - points(iP, 1)) * ...
                  (polygon(iPol, 2) - points(iP, 2));
               if abs(detI) < tol
                  areIn(iP) = true;
                  onEdge(iP) = true;
                  continue
               end
               rightCrossing = (detI > 0) == ...
                  (polygon(iPol + 1, 2) > polygon(iPol, 2));
               if rightCrossing
                  w(iP) = w(iP) + ...
                     2*(polygon(iPol + 1, 2) > polygon(iPol, 2)) - 1;
               end
            end
         end
      end
   end   
end

areIn(w > 0) = true;

end

