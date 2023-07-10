function update = fillNonDomSol(particle, nonDomSolutions)
%% fillNonDomSol fills matrices with non-dominated solutions
% This function fills the external archive and GlobalBest structure with solutions that were selected as non-dominated using the kungEtAl function

% INPUTS
% particle: Population, struct[1 x 1]
% nonDomSolutions: indices of non-dominated solutions

% OUTPUTS
% externalArchive: struct[1 x 1]

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

    for iND = 1:numel(nonDomSolutions)
        externalArchive(iND).Position = particle(nonDomSolutions(iND)).Position; %#ok<*AGROW>
        externalArchive(iND).Density = particle(nonDomSolutions(iND)).Density;
    end

update = externalArchive;

end