function curParticle = checkBoundaries(params, particle, problem, newSize)
%% checkBoundaries checks and updates particle positions based on wall type
% The position of each particle is checked and if it is outside the 
% solution space, its position is corrected depending on the selected wall 
% type.

% INPUTS
% problem: selected fitness function, struct[1 x 1]
% particle: Population, struct[1 x 1]
% params: parameters of PSO algorithm, struct[1 x 1]
% newSize: new size of the vector of the number of dimensions, double[1 x 1]

% OUTPUTS
% case absorbing/reflecting wall: 
% particle.Position: field[1 x newSize], the new correct position on 
% the boundary/inside of the solution space

% case invisible wall:
% particle.Density: field[1 x 2], a high value of the fitness function 
% that "degrades/discards" the solution and is no longer considered

% (c) 2023, Simona Sadleková, BUT, 174528@vut.cz

    switch params.Boundary
        case 'absorbing'
            ind = particle.Position < problem.Limits(1,1:newSize);
            particle.Position(ind) = problem.Limits(1,ind);
    
            ind = particle.Position > problem.Limits(2,1:newSize);
            particle.Position(ind) = problem.Limits(2,ind);
        case 'reflecting'
            ind = particle.Position < problem.Limits(1,1:newSize);
            if any(ind)
                temp = particle.Position(ind) - problem.Limits(1,ind);
                particle.Position(ind) = problem.Limits(1,ind) - temp;
            end
            ind = particle.Position > problem.Limits(2,1:newSize);
            if any(ind)
                temp = particle.Position(ind) - problem.Limits(2,ind);
                particle.Position(ind) = problem.Limits(2,ind) - temp;
            end
            ind = particle.Position < problem.Limits(1,1:newSize);
            if any(ind)
                particle.Position(ind) = problem.Limits(1,ind) + ...
                    (problem.Limits(2,ind) - problem.Limits(1,ind)).*...
                    rand(1, 1);
            end
            ind = particle.Position > problem.Limits(2,1:newSize);
            if any(ind)
                particle.Position(ind) = problem.Limits(1,ind) + ...
                    (problem.Limits(2,ind) - problem.Limits(1,ind)).*...
                    rand(1, 1);
            end
        case 'invisible'
            ind = particle.Position < problem.Limits(1,1:newSize); 
            if any(ind)
                particle.Density = 1e16;
            end
            ind = particle.Position > problem.Limits(2,1:newSize);
            if any(ind)
                particle.Density = 1e16;
            end
    end
    curParticle = particle;
end