function [G, M, E] = sim_basic(G, L, beta, q, algorithm, steps)
% Takes the spin-matrix side-length 'L', temperature inverse 'beta', number
% of possible spin states 'q', used algorithm 'algorithm', and number of
% algorithm-steps 'steps' (type float).
% Returns the thermodynamic averages of the quantities 'M', 'E', 'C', 'X'.

%%% NOTE: 'q' needed only for the Heat-Bath algorithm (Potts model).

%% Determining steps number
if algorithm == 1 || algorithm == 3 % Metropolis / Heat-Bath
    steps = L^2 * round(steps); % 'Sweeps'
elseif algorithm == 2               % Wolff
    steps = round(steps);
end

%% Simulating
for i = 1:steps
    if algorithm == 1
        [G, ~, ~] = step__metropolis__2D_ising(G, beta);
    elseif algorithm == 2
        [G, ~, ~] = step__wolff__2D_ising(G, beta);
    elseif algorithm == 3 
        [G, ~, ~] = step__heat_bath__2D_potts(G, beta, q);
    end
end

%% Computing macroscopic quantities
M = sum(sum(G));
E = - coupling_nearest_neighbors_2D(G);
