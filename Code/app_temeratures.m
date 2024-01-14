%% README

% This repository applies a Monte-Carlo simulation scheme, involving a
% system of spins arranged in a 2D-lattice, using different algorithms.
% Dynamics are based on the basic Ising-model hamiltonian: 
%   H0 = - J * sum_<i, j>(s_i * s_j) ,   <i, j>: i, j  nearest neighbors,
% including only nearest-neighbor interactions between spins, and no
% external magnetic field (which can be easily included).

% The scheme is flexible regarding both the possible spin values and the
% used algorithm, such that additional algorithms can be easily added to
% the modeling framework (by adding new step__*() functions and including
% them in sim_basic()). Furthermore, wide generalizations can be made
% with just a few steps (for example, an external field or higher order
% interactions can be included by slight modifications to the coupling or
% interaction functions, respectively). Introducing different models to it
% (such as higher-dimension lattices or angular spin directions) is
% reasonably achievable too, making this framework quite useful in my
% opinion.

% Hopefully, you'll find it useful too
%    OR HOSTEZKY


% -----------------------------------------------------------------------

% In this script, the dynamics of the system are to be simulated at a range
% of temperatures ('T'), as the outputs are the thermodynamics averages of
% the macroscopic, thermodynamical quantities 'M', 'E', 'C', 'X' (see
% 'Annotation glossary' below), which are then plotted as a function of 'T'
% (if wanted). The process is simulated in a 'quasi-static' way, given that
% the incremenets in 'T' are small enough ('enough' may be case-dependent).


%% Script Index:
%%% NOTE: Here, the general structure of this repository's 'Code' section
%%% is described. For a more specific description, look at each script
%%% specifically.

% nearest_neighbors_2D_open() and coupling_nearest_neighbors_2D() are
% the most basic functions, regarding spin ineteractions in a given matrix.

% The step__*() functions execute the spin dynamics (a single algorithm-
% step) using the interaction functions, each of which adheres to a
% different algorithm and model.
% form_cluster() is a sub-function of the Wolff-algorithm step function.

% cluster_size__wolff__2D_ising() finds the typical spin-cluster sizes
% in the Wolff algorithm at a given temperature.

% The *_correlation() functions regard the auto-correlation of the system
% between different steps (i.e. 'time' correlation), which helps to derive
% the system's decorrelation time, and thus to determine the needed number
% of steps between following measurements (in order to get meaningful data
% thermodynamically).
% plot__correlation() is called by sim_correlation().

% The sim_*() functions execute the actual simulations, and communnicate
% between the apply scripts and the step functions (or find_correlation()
% in the case of sim_correlation()). Their inner heirarchy is as such:
%   sim_temperatures() ---> sim_smpl_avrg() ---> sim_basic()
% plot__M_E_C_X__vs__T() is called by sim_temperatures().

% The 'app_*.m' scripts are the main scripts that apply the simulation
% scheme, and are executed directly by the user.

%%% General repository scheme:
%%%     Apply scripts ---> Simulation functions --->
%%%      ---> Step functions ---> Basic interaction functions


%% Annotation Glossary:
% L - lattice-side length [# spins]
% G - L * L spin matrix (i.e. lattice)
% q - number of possible spin states (i = 1, ..., L^2: s_i = 1, ..., q)

% J - Energy constant [Joule]
% kB - Boltzmann constant [Joule / Kelvin]

% T - temperature [J / kB]
% beta (1 / (kB * T)) - temperature "inverse" [1 / J]
% M - total magnetization [mu]
% E - total energy [J]
% C - heat capacity [kB]
% X - magnetic susceptibility [mu^2 / J]

% tau    - decorrelation 'time' [algorithm-steps/sweeps]
% sample - number of uncorrelated configurations sampled per data point in
%          a thermodynamic average (i.e. sample size)


%% Initializing parameters
clear; clc;

algorithm = 1; % 1 - Metroplis algorithm, Ising model
               % 2 - Wolff algorithm, Ising model
               % 3 - Heat-Bath algorithm, q-state Potts model

L = 5;
q = 2; % Ising model: q = 2,  Potts model: q >= 2


% Additional parameters - a reasonable choice
if algorithm == 1
    T_crit_exact = 2 / log(1 + sqrt(2)); % 'tau' peak-temperature
    tau_max      = 250; 
    tau_width    = 0.8;    
    
    T = 0.1:0.1:5;
    tau = tau_max * exp(- (T - T_crit_exact).^2 / (2 * tau_width^2)) + 30;
        tau(1:10) = 100; % [sweeps := L^2 steps]
    sample = [70 * ones(1, 15), 180 * ones(1, 15), 120 * ones(1, 20)];

elseif algorithm == 2
    T = 0.1:0.1:5;
    tau = [10 * ones(1, 15), 80 * ones(1, 15), 60 * ones(1, 8), ...
        20 * ones(1, 12)]; % [steps]
    sample = [10 * ones(1, 15), 150 * ones(1, 15), 120 * ones(1, 8), ...
        80 * ones(1, 12)];

elseif algorithm == 3
    T = 0.4:0.4:20;
    tau = [20 * ones(1, 5), 80 * ones(1, 15), 60 * ones(1, 30)]; % [sweeps]
    sample = [70 * ones(1, 15), 180 * ones(1, 10), 170 * ones(1, 25)];    
end


plt = 1; % Thermodynamic-quantities plotting parameter:
         % 0 - do not plot
         % 1 - plot

% Halts execution at exception
if (algorithm == 1 || algorithm == 2) && q > 2
    warning('For Ising model simulation, q = 2 must be defined')
    return
end

%% Simulating
M = nan(length(L), length(T)); 
E = nan(length(L), length(T));
C = nan(length(L), length(T));
X = nan(length(L), length(T));

for i = 1:length(L)
    [M(i, :), E(i, :), C(i, :), X(i, :)] = sim_temperatures(L(i), T, q, ...
        algorithm, tau, sample, plt);
end

%% Saving data
file_prefix = ['..', filesep, 'Data', filesep, 'temperatures__L_', int2str(L)];

if algorithm == 1
    save([file_prefix, '__Metropolis__Ising.mat']);
elseif algorithm == 2
    save([file_prefix, '__Wolff__Ising.mat']);
elseif algorithm == 3
    save([file_prefix, '__HeatBath__', mat2str(q), 'Potts.mat']);
end
