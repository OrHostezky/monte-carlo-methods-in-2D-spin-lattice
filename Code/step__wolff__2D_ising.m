function [G, dM, dE] = step__wolff__2D_ising(G, beta)
% Takes a spin-matrix 'G' and the temperature inverse 'beta'. Returns the
% updated matrix 'G', and the resulting changes in magnetization ('dM'),
% and energy ('dE').
% Procedure is according to Wolff algorithm, 2D-Ising model.

%% Forming a cluster
L = size(G, 1);
i = randi(L);
j = randi(L);

added = nan(2, L^2); % Indices of added spins
added(:, 1) = [i; j];
[added, ~] = form_cluster(G, beta, G(i, j), added, 2);

%% Updating
M0 = sum(sum(G));
E0 = - coupling_nearest_neighbors_2D(G);

for k = 1:size(added, 2)
    G(added(1, k), added(2, k)) = - G(added(1, k), added(2, k));
end

dM = sum(sum(G)) - M0;
dE = - coupling_nearest_neighbors_2D(G) - E0;
