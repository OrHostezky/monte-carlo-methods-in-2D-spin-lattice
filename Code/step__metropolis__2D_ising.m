function [G, dM, dE] = step__metropolis__2D_ising(G, beta)
% Takes a spin-matrix 'G' and the temperature inverse 'beta'. Returns the
% updated matrix 'G', and the resulting changes in magnetization ('dM'),
% and energy ('dE').
% Procedure is according to Metropolis algorithm, 2D-Ising model.

%% Choosing a spin
L = size(G, 1);
i = randi(L);
j = randi(L);
Gij0 = G(i, j);

%% Updating
[val, ~] = nearest_neighbors_2D_open(G, i, j);
ssnn = sum(val == Gij0); % 'ssnn': same-sign nearest neighbors
dE = 4 * ssnn - 8;

if rand < exp(- beta * dE)
    G(i, j) = - Gij0;
end
dM = G(i, j) - Gij0;
 