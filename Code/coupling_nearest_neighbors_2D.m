function coupling = coupling_nearest_neighbors_2D(G)
% Takes a square spin-matrix 'G' and returns its coupling factor 'coupling',
% according to the Ising-model Hamiltonian:
%   H0 = - J * sum_<i, j>(s_i * s_j) ,   <i, j>: i, j nearest neighbors.

%%% NOTE: Considers nearest neighbors interactions only, and "open"
%%% boundaries: G(L+1,L+1) := G(1,1).

L = size(G, 1);

coupling = 0;
for i = 1:L
    for j = 1:L
        [nearest_neighbors_val, ~] = nearest_neighbors_2D_open(G, i, j);
        coupling = coupling + G(i, j) * sum(nearest_neighbors_val) / 2;
    end
end
