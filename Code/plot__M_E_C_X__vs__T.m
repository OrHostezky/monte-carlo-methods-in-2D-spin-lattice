function plot__M_E_C_X__vs__T(L, T, q, algorithm, M, E, C, X)
% Takes the spin-matrix side-length 'L', temperature vector 'T', number of
% possible spin states 'q', used algorithm 'algorithm', and vectors of the
% thermodynamic quantities 'M', 'E', 'C', 'X'.
% Plots these quantities as a function of temperature, and saves figure.

figure

%% Magnetization
subplot(2, 2, 1)
plot(T, M / L^2, '.')
xlim([min(T), max(T)])
if algorithm == 1 || algorithm == 2
    ylim([0, 1])
else
    ylim([1, q])
end
ylabel('$|\langle m \rangle| [\mu]$', 'Interpreter', 'latex', 'FontSize', 12)
title('Mean Spin Magnetization', 'FontSize', 12)

%% Magnetic susceptibility
subplot(2, 2, 2)
plot(T, X, '.')
xlim([min(T), max(T)])
ylabel('$\chi_M [\mu^2 / J]$', 'Interpreter', 'latex', 'FontSize', 12)
title('Magnetic Susceptibility', 'FontSize', 12)

%% Energy
subplot(2, 2, 3)
plot(T, E / (2 * L^2), '.')
xlim([min(T), max(T)])
xlabel('$T [J/k_B]$', 'Interpreter', 'latex', 'FontSize', 12)
ylabel('$\langle E \rangle / 2N [J]$', 'Interpreter', 'latex', ...
    'FontSize', 12)
title('Mean Interaction Energy', 'FontSize', 12)

%% Heat capacity
subplot(2, 2, 4)
plot(T, C, '.')
xlim([min(T), max(T)])
xlabel('$T [J/k_B]$', 'Interpreter', 'latex', 'FontSize', 12)
ylabel('$C_V [k_B]$', 'Interpreter', 'latex', 'FontSize', 12)
title('Heat Capacity', 'FontSize', 12)

%% Titling & Saving
sgtitle_prefix = ['Thermodynamic averages VS temperature', newline, ...
    'L = ', int2str(L)];
file_prefix = ['..', filesep, 'Plots', filesep, 'M_E_C_X_vs_T__L_', int2str(L)];

if algorithm == 1     % Metroplis
    sgtitle([sgtitle_prefix, ' ,   Metropolis algorithm'])
    saveas(gcf, [file_prefix, '__Metropolis__Ising.fig'])
    saveas(gcf, [file_prefix, '__Metropolis__Ising.png'])

elseif algorithm == 2 % Wolff
    sgtitle([sgtitle_prefix, ' ,   Wolff algorithm'])
    saveas(gcf, [file_prefix, '__Wolff__Ising.fig'])
    saveas(gcf, [file_prefix, '__Wolff__Ising.png'])

elseif algorithm == 3 % Heat Bath
    sgtitle([sgtitle_prefix, ' ,   Heat-Bath algorithm for ', ...
        int2str(q), '-state Potts model'])
    saveas(gcf, [file_prefix, '__HeatBath__', int2str(q), 'Potts.fig'])
    saveas(gcf, [file_prefix, '__HeatBath__', int2str(q), 'Potts.png'])
end
