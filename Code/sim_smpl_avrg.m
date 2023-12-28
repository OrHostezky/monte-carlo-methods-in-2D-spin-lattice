function [M, E, C, X, G] = sim_smpl_avrg(L, T, q, algorithm, tau, sample, G0)
%%%%% This scripts serves as an envelope to 'sim_basic.m' %%%%%
% Takes the spin-matrix side-length 'L', temperature 'T', number of
% possible spin states 'q', used algorithm 'algorithm', estimated
% decorrelation time 'tau' (related to the number of algorithm-steps
% between following measurements), and sample size 'sample'.
% Returns the thermodynamic averages of the quantities 'M', 'E', 'C', 'X'.

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

%% Simulating
M = nan(1, sample);
E = nan(1, sample);

for i = 1:sample
    [G, Mi, Ei] = sim_basic(G, L, beta, q, algorithm, 2 * tau);
    M(i) = Mi;
    E(i) = Ei;
end

%% Computing quantities
M_mean = nan(1, sample^2);
E_mean = nan(1, sample^2);
C = nan(1, sample^2);
X = nan(1, sample^2);

M_mean(1) = mean(abs(M));
E_mean(1) = mean(E);
C(1) = beta^2 * (mean(E.^2) - E_mean(1)^2);
X(1) = beta * (mean(M.^2) - M_mean(1)^2);

% Bootstrapping
for i = 2:sample^2
    M_rand = nan(1, sample);
    E_rand = nan(1, sample);

    for j = 1:sample
        M_rand(j) = M(randi(sample));
        E_rand(j) = E(randi(sample));
    end
    
    M_mean(i) = mean(abs(M_rand));
    E_mean(i) = mean(E_rand);
    C(i) = beta^2 * (mean(E_rand.^2) - E_mean(i)^2);
    X(i) = beta * (mean(M_rand.^2) - M_mean(i)^2);
end

% Averaging
M = mean(M_mean);
E = mean(E_mean);
C = mean(C);
X = mean(X);
