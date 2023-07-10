function [particle, MaxVelocity, MinVelocity] = initParticles(problem, params)
%% initParticles creates a population of particles
% The number of dimensions, position and velocity is randomly generated for individual particles

% INPUTS
% problem: selected fitness function, struct[1 x 1]
% params: parameters of PSO algorithm, struct[1 x 1]

% OUTPUTS
% particle: struct[1 x 1] which stores the created Population,
% MaxVelocity: double[1 x 1]
% MinVelocity: double[1 x 1]

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

    for i = 1:params.PopSize
    
        % Generate Random Dimension from Dimension List
        particle(i).Dimension = params.nVarsList(randperm(length(params.nVarsList),1));
    
        nVar = particle(i).Dimension;
    
        % Generate Random Positions of Particles
        particle(i).Position = problem.Limits(1,1:nVar) + (problem.Limits(2,1:nVar) - problem.Limits(1,1:nVar)).*rand(1, nVar);
    
        % Initialize Velocity
        MaxVelocity = 0.2*(problem.Limits(2,:) - problem.Limits(1,:));
        MinVelocity = -MaxVelocity;
    
        particle(i).Velocity = MinVelocity(1:nVar) + (MaxVelocity(1:nVar) - MinVelocity(1:nVar)).*rand(1,nVar);
    
        % Evaluation
        if isfield(problem, 'polygon')
           particle(i).Density = problem.DensityFunction(particle(i).Position, ...
              problem.polygon);
        else
           particle(i).Density = problem.DensityFunction(particle(i).Position);
        end
            
        % Update the Personal Best
        particle(i).Best.Dimension = particle(i).Dimension;
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Density = particle(i).Density;
    
    end
end