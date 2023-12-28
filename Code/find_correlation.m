function [dt, auto_correlation] = find_correlation(L, M, algorithm)
% Takes the spin-matrix side-length 'L', a time-series magnetization vector
% 'M', and the used algorithm 'algorithm'.
% Returns a vector of lag-times 'dt' and the corresponding auto-correlation
% function 'auto_correlation', defined by:
%   A(dt) / A(dt = 0):   A(dt) := <(M(t) - <M>) * (M(t + dt) - <M>)> ,
% where <> is the thermodynamic average (represented here by the temporal
% average).

%%% NOTE: Computation is halted whenever the auto-correlation drops below
%%% 10^(-5).

%% Initializing time-lag vector
t_max = length(M);
dt = 0 : 1 : t_max - 1;

%% Computing auto-correlation
if algorithm == 2
    M = abs(M);
end
M_mean = mean(M);
auto_correlation = nan(1, length(dt));

% Computing for dt = 0 (reference)
A0 = 0;
for t = 1:t_max
    A0 = A0 + (M(t) - M_mean)^2;
end
A0 = A0 / t_max;
auto_correlation(1) = A0;

% Computing for dt > 0
for i = 2:length(dt)
    temp = 0;
    for t = 1 : t_max - dt(i)
        temp = temp + (M(t) - M_mean) * (M(t + dt(i)) - M_mean);
    end
    temp = temp / t;
    
    % Stopping computation at very small values
    if temp / A0 > 1e-5
        auto_correlation(i) = temp;
    else
        break
    end
end

% Removing unimportant cells
dt(isnan(auto_correlation)) = []; 
auto_correlation(isnan(auto_correlation)) = [];

% Normalizing to auto-correlation(dt = 0) = 1
auto_correlation = auto_correlation / A0; 

%% Unit standardizing
if algorithm == 1 || algorithm == 3 % Metropolis / Heat-Bath
    dt = dt / L^2; % 'Sweeps'
end
