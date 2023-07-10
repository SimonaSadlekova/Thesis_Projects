function nOpt = getNOpt(f, nOptList, nParts, order)
%% getNOpt return optimal dimensionality of solution 
% This function computes optimal dimensionality of solutions _f_. This
% function is used by multi-objective VND problems. Dimensionalities are
% linearly incresing or decreasing over Pareto-front based on _order_
% argument. Number of parts over Pareto-front is specified by _nParts_
% value.
%
%  INPUTS
%   f: fitness values, double [nAgents x nObjs]
%   nOptList: list of possible optimal dimensionalities, double [N x 1]
%   nParts: number of parts on Pareto-front, double [1 x 1]
%   order: whether dimensionality increases or decreases, logical [nParts x 1]
% 
%  OUTPUTS
%   nOpt: optimal dimensionalities, double [nAgents x 1]
% 
%  SYNTAX
%  
%  nOpt = getNOpt(f, nOptList, nParts, order)
%
% Included in FOPS, info@antennatoolbox.com
% (c) 2018, Martin Marek, BUT, martin.marek@antennatoolbox.com
% mcode
f1 = f(:, 1);
f2 = f(:, 2);
thmax = pi/2/nParts;
tempth(:, 1) = acos(f2./sqrt(f1.^2+f2.^2));
iPart = floor(tempth/thmax)+1;
temp1 = iPart>nParts;
iPart(temp1)=nParts;
tempth = mod(tempth, thmax);   
tempth(temp1) = thmax;
for i = 1:nParts
   if order(i)
      tempth(iPart==i) = thmax-tempth(iPart==i);
   end
end
th = tempth;
N = numel(nOptList);
H = floor((th/thmax)*(N));
H(H>N-1) = N-1;
nOpt = nOptList(1+H);
end