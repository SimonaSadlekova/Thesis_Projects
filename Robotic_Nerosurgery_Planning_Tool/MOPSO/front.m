function indexes = front(f, SVI)
%% front function - variant for small populations - faster computation.
% Elementary function of kungEtAl algorithm. It is recursively called. It splits
% population to top and bottom half. Bottom half cannot dominate any solution of
% top half. Function determines only which solutions of bottom half is dominated
% by top half and returns indexes of non-dominated solutions.
%
%  INPUTS
%   f: fitness functions values, double [N x M]
%   SVI: sorted vector of indices, double [N x 1]
%
%  OUTPUTS
%   indexes: non-dominated solutions, double [M x 1]
if numel(SVI) == 1
   indexes = SVI;
else
   topVI = SVI(1:floor(end/2));
   bottomVI = SVI(floor(end/2)+1:end);
   % recursive call
   indexesT = front(f, topVI);
   indexesB = front(f, bottomVI);
   
   nT = numel(indexesT);
   nB = numel(indexesB);
   
   badIndexes = false(nB, 1);
   for iB = 1:nB
      option = f(indexesT, :) - repmat(f(indexesB(iB), :), nT, 1);
      if any(option, 2)
         if any(all(option <= 0, 2)) % top element dominates bottom element
            badIndexes(iB) = true;
         end
      else  % fitness values are the same
         badIndexes(iB) = true;      
      end
   end
   indexesB(badIndexes) = [];
   indexes = [indexesT; indexesB];
end

