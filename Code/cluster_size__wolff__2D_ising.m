function [size_mean, size_std, sizes] = cluster_size__wolff__2D_ising(L, ...
    T, tau, sample)
% Takes the spin-matrix side-length 'L', temperature 'T', estimated
% decorrelation time 'tau' (related to the number of algorithm-steps 
% between following measurements), and sample size 'sample'.
% Returns a vector of same-sign spins cluster sizes in a step of the Wolff
% algorithm, including mean and STD values.

%% Initializing
beta = 1 / T;

G = randi(2, [L, L]);
G(G == 2) = - 1;

%% Sampling
sizes = nan(1, n);
for i = 1:sample
    [G, ~, ~] = sim_basic(G, L, beta, 2, 2, 2 * tau);
    Gtemp = G;
    [G, ~, ~] = step__wolff__2D_ising(Gtemp, beta);
    sizes(i) = sum(sum(abs((G - Gtemp) / 2))) / L^2;
end

%% Averaging
size_mean = mean(cluster_size);
size_std = std(cluster_size);
