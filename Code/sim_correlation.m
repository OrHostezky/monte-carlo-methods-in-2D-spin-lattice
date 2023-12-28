function [dt, auto_correlation, t, M] = sim_correlation(L, T, q, ...
    algorithm, steps, plt)
% Takes the spin-matrix side-length 'L', temperature 'T', number of
% possible spin states 'q', used algorithm 'algorithm', number of
% algorithm-steps 'steps' (type int), and plotting variable 'plt' (0 - do
% not plot, 1 - plot).
% Returns a vector of lag-times 'dt', the corresponding auto-correlation
% function 'auto_correlation', and the magnetization time-series ('M'). In
% addition, it will plot these (if plt = 1). 

%% Initializing lattice
beta = 1 / T;

if ~exist('G0', 'var')
    G = randi(q, [L, L]); % q = 2 for Ising model
    if algorithm == 1 || algorithm == 2
        G(G == 2) = - 1; % Symmetric values (+-1)
    end
else
    G = G0;
end

% Diminishing initial condition's effect
[G, M, ~] = sim_basic(G, L, beta, q, algorithm, steps); 

%% Determining steps number

if algorithm == 1 || algorithm == 3 % Metropolis / Heat-Bath
    steps = L^2 * steps; % 'Sweeps'
    t = (0:steps) / L^2;
    time_unit = 'sweeps';
elseif algorithm == 2               % Wolff
    t = 0:steps;
    time_unit = 'steps';
end

%% Simulating
M = [M, nan(1, steps)];

for i = 1:steps
    if algorithm == 1
        [G, dM, ~] = step__metropolis__2D_ising(G, beta);
    elseif algorithm == 2
        [G, dM, ~] = step__wolff__2D_ising(G, beta);
    elseif algorithm == 3 
        [G, dM, ~] = step__heat_bath__2D_potts(G, beta, q);
    end
    M(i + 1) = M(i) + dM;
end

%% Computing auto-correlation
[dt, auto_correlation] = find_correlation(L, M, algorithm);

%% Plotting
if plt
    plot__correlation(L, T, q, algorithm, time_unit, dt, ...
        auto_correlation, t, M)
end
