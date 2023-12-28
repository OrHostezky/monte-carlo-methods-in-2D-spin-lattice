function plot__correlation(L, T, q, algorithm, time_unit, dt, ...
    auto_correlation, t, M)
% Takes the spin-matrix side-length 'L', temperature 'T', number of
% possible spin states 'q', used algorithm 'algorithm', time-unit string
% 'time_unit', a vector of time-lags 'dt', corresponding auto-correlation
% function 'auto_correlation', a time vector 't', and the corresponding
% magnetization time-series ('M').
% Plots both the auto-correlation as a function of the time-lag, and the
% (mean spin) magnetization time-series, and saves figure.

figure

%% Magnetization
subplot(2, 1, 2)
plot(t, M / L^2, '.')
if algorithm == 1 || algorithm == 2
    ylim([-1, 1])
else
    ylim([1, q])
end
xlabel(['$t [', time_unit, ']$'], 'Interpreter', 'latex', 'FontSize', 12)
ylabel('$m(t) [\mu]$', 'Interpreter', 'latex', 'FontSize', 12)
title('Mean Spin Magnetization', 'FontSize', 12)

%% Auto-correlation
subplot(2, 1, 1)
plot(dt, auto_correlation,'.')
set(gca, 'YScale', 'log')
ylim([0.1, 1])
xlabel(['$\Delta t [', time_unit, ']$'], 'Interpreter', 'latex', ...
    'FontSize', 12)
ylabel(['$\Bigl\langle \bigl(m(t) - \langle m \rangle \bigr) \bigl(m(t +' ...
    '\Delta t) - \langle m \rangle \bigr) \Bigr\rangle$'], 'Interpreter', ...
    'latex')
title('Auto-correlation', 'FontSize', 12)

%% Saving
subtitle_prefix = ['L = ', int2str(L), ' ,   T = ', num2str(T)];
file_prefix = ['..', filesep, 'Plots', filesep, 'correlation__L_', ...
    int2str(L), '__T_', num2str(T)];

if algorithm == 1     % Metroplis
    subtitle([subtitle_prefix, ' ,   Metropolis algorithm'])
    saveas(gcf, [file_prefix, '__Metropolis__Ising.fig'])
    saveas(gcf, [file_prefix, '__Metropolis__Ising.png'])

elseif algorithm == 2 % Wolff
    subtitle([subtitle_prefix, ' ,   Wolff algorithm'])
    saveas(gcf, [file_prefix, '__Wolff__Ising.fig'])
    saveas(gcf, [file_prefix, '__Wolff__Ising.png'])

elseif algorithm == 3 % Heat Bath
    subtitle([subtitle_prefix, ' ,   Heat-Bath algorithm for ', int2str(q), ...
        '-state Potts model'])
    saveas(gcf, [file_prefix, '__HeatBath__', int2str(q), 'Potts.fig'])
    saveas(gcf, [file_prefix, '__HeatBath__', int2str(q), 'Potts.png'])
end
