function [added, col] = form_cluster(G, beta, Gij, added, col)
% Takes a spin-matrix 'G', the temperature inverse 'beta', a value of added
% spin 'Gij', a position-array of added spins 'added', and a column to fill
% 'col'.
% Returns updated position-array of added spins 'added' and column to fill
% 'col' for self-calls (recursion), effictively forming a complete cluster.

%% Finding nearest neighbors
i = added(1, col - 1);
j = added(2, col - 1);
[nn_val, nn_pos] = nearest_neighbors_2D_open(G, i, j); % 'nn': nearest_neighbors

%% Forming a cluster
for k = 1:length(nn_val)
    if nn_val(k) == Gij % Checking if same-sign neighbor
        isAdded = 0;
        l = 1;
        while ~ isAdded && l < col % Checking if already added
            if nn_pos(:, k) == added(:, l)
                isAdded = 1;
            end
            l = l + 1;
        end
        
        if ~ isAdded 
            if rand < 1 - exp(- 2 * beta)     % Addition probability
                added(:, col) = nn_pos(:, k); % Adding a spin
                [added, col] = form_cluster(G, beta, Gij, added, col + 1);
            end
        end
    end
end

%% Discarding unfilled cells
if size(added, 2) >= col
    added(:, col:end) = [];
end
