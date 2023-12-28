function [G, dM, dE] = step__heat_bath__2D_potts(G, beta, q)
% Takes a spin-matrix 'G', the temperature inverse 'beta', and the number
% of possible spin states 'q'. Returns the updated matrix 'G', and the
% resulting changes in magnetization ('dM'), and energy ('dE').
% Procedure is according to Metropolis algorithm, q-state 2D-Potts model.

%% Choosing a spin
L = size(G, 1);
i = randi(L);
j = randi(L);
Gij0 = G(i, j);

%% Updating
[nn_val, ~] = nearest_neighbors_2D_open(G, i, j); % 'nn': nearest neighbors
dE = - sum(nn_val) * ((1:q) - Gij0);              % Possible energy changes
p = exp(- beta * dE) ./ sum(exp(- beta * dE));    % Probabilities

r = rand;
for s = 1:q
    if r < sum(p(1:s)) % Gillespie choice of spin state
        G(i, j) = s;
        break
    end
end

dM = s - Gij0;
dE = dE(s);
