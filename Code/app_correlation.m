%% README

% This script applies a simulation that computes the auto-correlation
% between different steps (i.e. 'time' correlation), of a system of spins
% arranged in a 2D-lattice. This function is defined by:
%   A(dt) / A(dt = 0):   A(dt) := <(M(t) - <M>) * (M(t + dt) - <M>)> ,
% where M(t) is the magnetization of the system, <> is the thermodynamic
% average (represented here by the temporal average), and dt is the lag-
% time.

% The function may be computed at a range of temperatures ('T'), and will
% be plotted at each case (if wanted) as a function of the lag-time, along
% with the magnetization ('M') time-series.
% The auto-correlation function helps to derive the system's decorrelation
% time, and thus to determine the needed number of steps between following
% measurements of thermodynamic quantities (in order to get meaningful data 
% thermodynamically).

%%% NOTE: for a Script Index and Annotation Glossary, see
%%% 'app_temperatures.m'.

%% Initializing parameters
clear; clc;

algorithm = 1; % 1 - Metroplis algorithm, Ising model
               % 2 - Wolff algorithm, Ising model
               % 3 - Heat-Bath algorithm, q-state Potts model

L = 20;
q = 2; % Ising model: q = 2,  Potts model: q >= 2
T = 10;
steps = 50; % Sweeps (L^2 steps) for Metropolis and Heat-Bath algorithms

plt = 1; % Auto-correlation and magnetization plotting parameter:
         % 0 - do not plot
         % 1 - plot

% Halts execution at exception
if (algorithm == 1 || algorithm == 2) && q > 2
    warning('For an Ising model simulation, define q = 2')
    return
end

%% Simulating
dt               = cell(1, length(T));
auto_correlation = cell(1, length(T));
t                = cell(1, length(T));
M                = cell(1, length(T));

for i = 1:length(T)
    [dt{i}, auto_correlation{i}, t{i}, M{i}] = sim_correlation(L, T(i), ...
        q, algorithm, steps(i), plt);
end

%% Saving data
file_prefix = ['..', filesep, 'Data', filesep, 'correlation__L_', ...
    int2str(L), '__T_', num2str(T)];

if algorithm == 1
    save([file_prefix, '__Metropolis__Ising.mat']);
elseif algorithm == 2
    save([file_prefix, '__Wolff__Ising.mat']);
elseif algorithm == 3
    save([file_prefix, '__HeatBath__', mat2str(q), 'Potts.mat']);
end
