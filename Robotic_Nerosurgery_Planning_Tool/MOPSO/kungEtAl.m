function indexes = kungEtAl(fitness)
%% kungEtAl is non-dominated sorting method
% Solutions (pointer to solutions) are sorted according to first objective
% function and then function _front_ or _frontLong_ is called, which returns
% indices of non-dominated solutions of _fitness_. Since solution (pointers to
% solutions) are sorted, one compare operation is sufficient to determine
% whether "top" subpopulation dominates "bottom" subpopulation.
%
% Sorting is in more detail described in:
% DEB, Kalyanmoy. Multi-objective optimization using evolutionary algorithms.
% John Wiley & Sons, 2001.
%
% sort the population according to first objective function, be aware of order
% in second column if values in first objective are the same.

[~, SVI] = sortrows(fitness, [1, 2]);
indexes = front(fitness, SVI);
indexes = sort(indexes);


