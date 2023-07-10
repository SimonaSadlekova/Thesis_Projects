function out = VNDMOPSO(problem, params)
%% VNDMOPSO performs optimization based on VNDMOPSO algorithm
% This function performs an Particle Swarm Optimization algorithm for 
% multi-objective optimization problems.

% INPUTS
%   problem: selected fitness function, struct[1 x 1]
%   params: parameters of PSO algorithm, struct[1 x 1]

% OUTPUTS
%   out: struct[1 x 1] which stores the created Population, 
%   the found GlobalBests and the contents of the External Archive

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

%% Problem Definition

fitnessFunction = problem.DensityFunction;
nVar = size(problem.Limits, 2);   % Number of Unknown (Decision) Variables
VarSize = [1 nVar];               % Matrix Size of Decision Variables

%% Parameters of VNDMOPSO

MaxIter = params.MaxIter;      % Maximum Number of Iterations

PopSize = params.PopSize;      % Population Size

w = params.w;                  % Inertia Coefficient
wdamp = params.wdamp;          % Damping Ratio of Inertia Coefficient
c1 = params.c1;                % Personal Accelaration Coefficient
c2 = params.c2;                % Global Accelaration Coefficient
nVarsList = params.nVarsList;  % List of Dimensions
% nOptList = params.nOptList;
dimProbabilities = params.dimProbabilities;

MaxVelocity = 0.2*(problem.Limits(2,:) - problem.Limits(1,:));
MinVelocity = -MaxVelocity;

%% Initialization

empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.Density = [];
empty_particle.Best.Position = [];
empty_particle.Best.Density = [];
empty_particle.Dimension = [];

% Create Population Array
particle = repmat(empty_particle, PopSize, 1);

% Initialize Global Best
GlobalBest.Density = inf;

% Initialize Population Members
[particle, MaxVelocity, MinVelocity] = initParticles(problem, params);

% Create An External Archive
nObj = size(particle(1).Density, 2);
nonDomSolutions = kungEtAl(reshape([particle.Density], nObj, [])');

externalArchive = fillNonDomSol(particle, nonDomSolutions);

% Update Global Best
sol = randi(numel(nonDomSolutions), [PopSize, 1]); % sol is matrix (PopSize x 1) with Y pseudorandom integers

GlobalBest = fillNonDomSol(externalArchive, sol);

%% Main Loop of VNDMOPSO

for iter = 1:MaxIter
    
    for i = 1:PopSize
        % Determine the new D
        p1 = dimProbabilities(1);  % Probability of Dimension of GlobalBest.Position
        p2 = dimProbabilities(2);  % Probability of Dimension of Particle(i).Best.Position
        p3 = dimProbabilities(3);  % Probability of Dimension of Particle(i).Position
        
        % If number of dimensions of GBEST, PBEST and Position is not equal, generate a random number r
        newSize = particle(i).Dimension;
        tempV = particle(i).Velocity;
        tempP = particle(i).Position;
        tempGB = GlobalBest(i).Position;
        tempPB = particle(i).Best.Position;
        if ((particle(i).Dimension ~= size(GlobalBest(i).Position, 2)) || ...
                (particle(i).Dimension ~= particle(i).Best.Dimension) || ...
                (size(GlobalBest(i).Position, 2) ~= particle(i).Best.Dimension))
            r = rand;
            if r <= p1
                % work with the GBEST dimension
                newSize = size(GlobalBest(i).Position, 2);
            elseif r > p1 && r <= p1 + p2
                % work with the PBEST dimension
                newSize = size(particle(i).Best.Position, 2);
            else
                % work with the Position dimension
                newSize = size(particle(i).Position, 2);
            end
            % what remains, temporarily delete
            if length(GlobalBest(i).Position) > newSize
                tempGB = GlobalBest(i).Position(:, 1:newSize);
            end
            if length(particle(i).Best.Position) > newSize
                tempPB = particle(i).Best.Position(:, 1:newSize);
            end
            if length(particle(i).Position) > newSize
                tempP = particle(i).Position(:, 1:newSize);
                tempV = particle(i).Velocity(:, 1:newSize);
            end 
            
            % what is missing, supply randomly/copy from PBEST
            if length(GlobalBest(i).Position) < newSize
               tempGB = problem.Limits(1,1:newSize) + ...
                  (problem.Limits(2,1:newSize) - problem.Limits(1,1:newSize)).*...
                  rand(1, newSize);
               tempGB(1:size(GlobalBest(i).Position, 2)) = GlobalBest(i).Position;
            end
            if length(particle(i).Best.Position) < newSize
               tempPB = problem.Limits(1,1:newSize) + ...
                  (problem.Limits(2,1:newSize) - problem.Limits(1,1:newSize)).*...
                  rand(1, newSize);
               tempPB(1:length(particle(i).Best.Position)) = particle(i).Best.Position;
            end
            if length(particle(i).Position) < newSize
               tempP = problem.Limits(1,1:newSize) + ...
                  (problem.Limits(2,1:newSize) - problem.Limits(1,1:newSize)).*...
                  rand(1, newSize);
               tempP(1:length(particle(i).Position)) = particle(i).Position;
               tempV = MinVelocity(1,1:newSize) + ...
                  (MaxVelocity(1,1:newSize) - MinVelocity(1,1:newSize)).*...
                  rand(1, newSize);
               tempV(1:length(particle(i).Position)) = particle(i).Velocity;
            end 
        end

        % Update Velocity
        particle(i).Velocity = w*tempV ...
            + c1*rand(1, newSize).*(tempPB - tempP) ...
            + c2*rand(1, newSize).*(tempGB - tempP);

        % Update Position
        particle(i).Position = tempP + particle(i).Velocity; 
        particle(i).Dimension = numel(particle(i).Position);

        % Apply Lower and Upper Bound Limits
        curParticle = checkBoundaries(params, particle(i), ...
           problem, newSize);
        particle(i).Position = curParticle.Position;
        if strcmp(params.Boundary, 'invisible')
           particle(i).Density = curParticle.Density;
        else
           if isfield(problem, 'polygon')
              particle(i).Density = problem.DensityFunction(curParticle.Position, ...
                 problem.polygon);
           else
              particle(i).Density = problem.DensityFunction(curParticle.Position);
           end
        end              

        % Update Personal Best
        if particle(i).Density < particle(i).Best.Density
            
            particle(i).Best.Dimension = particle(i).Dimension;
            particle(i).Best.Position = particle(i).Position;
            particle(i).Best.Density = particle(i).Density;
        end      
    end
    
    % Update External Archive
    ExArchSize = size(externalArchive, 2);
    combX = cell(PopSize + ExArchSize, 1);
    combF = zeros(PopSize + ExArchSize, nObj);
    for iN = 1:PopSize + ExArchSize
       if iN <= PopSize
          combX{iN} = particle(iN).Position;
          combF(iN,:) = particle(iN).Density;
       else
          combX{iN} = externalArchive(iN-PopSize).Position;
          combF(iN,:) = externalArchive(iN-PopSize).Density;
       end
       
    end
    nonDomSolutions = kungEtAl(combF);
    
    for iND = 1:numel(nonDomSolutions)
        externalArchive(iND).Position = combX{nonDomSolutions(iND)};
        externalArchive(iND).Density = combF(nonDomSolutions(iND), :);
    end

    % trim external archive
    Archive = size(externalArchive, 2);
    if Archive > PopSize
        % normalize objective-space
        F = externalArchive.Density;
        F_min = repmat(min(F), Archive, 1);
        F_max = repmat(max(F), Archive, 1);
        F_norm = (F-F_min) ./ (F_max-F_min);
        [~, indexes] = sort(F_norm(:, 1)); % sort according to first dimension
        F_norm = F_norm(indexes, :);
        % Create an Ascending Heap
        heap = 1:Archive;
        heap = heap(indexes);
        % While size of Heap is bigger than PopSize, remove an element
        % with minimum CD
        for iNon = 1:Archive - PopSize
            % calculate crowding distances
            Archive = size(F_norm, 1);
            CD = inf(Archive, 1);
            for iA = 2:Archive-1
                ED1 = sqrt(sum(F_norm(iA, :) - F_norm(iA-1, :)).^2);
                ED2 = sqrt(sum(F_norm(iA, :) - F_norm(iA+1, :)).^2);
                CD(iA) = ED1 * ED2;
            end
            [~, minCD] = min(CD);
            F_norm(minCD, :) = [];
            heap(minCD) = [];
        end

        heap = sort(heap);

        for iA = 1:PopSize
           externalArchive(iA).Position = externalArchive(heap(iA)).Position;
           externalArchive(iA).Density = externalArchive(heap(iA)).Density;
        end
        externalArchive(PopSize+1:end) = [];
    end

    % Update Global Best
    Archive = size(externalArchive, 2);
    sol = randi(Archive, [PopSize, 1]);

    GlobalBest = fillNonDomSol(externalArchive, sol);

    % Damping Inertial Coefficient
    w = w * wdamp;
end

out.pop = particle;
out.BestSolution = GlobalBest;
out.exArchive = externalArchive;

end