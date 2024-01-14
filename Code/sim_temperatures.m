function [M, E, C, X] = sim_temperatures(L, T, q, algorithm, tau, sample, plt)
%%%%% This scripts serves as an envelope to sim_smpl_avrg() %%%%%
% Takes the spin-matrix side-length 'L', temperatures vector 'T', number of
% possible spin states 'q', used algorithm 'algorithm', vector 'tau' of
% estimated decorrelation times (related to the number of algorithm-steps
% between following measurements), vector 'sample' of the corresponding
% sample sizes, and plotting variable 'plt' (0 - do not plot, 1 - plot).
% Returns vectors of the thermodynamic quantities 'M', 'E', 'C', 'X', and
% will plot (if plt = 1) these quantities as a function of temperature.

%%% NOTE: 'T', 'tau', and 'sample' must have the same length!

%% Initializing
M = nan(1, length(T));
E = nan(1, length(T));
C = nan(1, length(T));
X = nan(1, length(T));

%% Simulating
[M(1), E(1), C(1), X(1), G] = sim_smpl_avrg(L, T(1), q, algorithm, ...
    tau(1), sample(1));
for i = 2:length(T)
    % Initializing with previous final configuration ("quasi-static")
    [M(i), E(i), C(i), X(i), G] = sim_smpl_avrg(L, T(i), q, algorithm, ...
        tau(i), sample(i), G); 
end

%% Plotting
if plt
    plot__M_E_C_X__vs__T(L, T, q, algorithm, M, E, C, X)
end
