% HD attractor & progress plots for Fig 6A

figure('Color', 'w')
LineWidth = 3;
FontSize = 28;
row = 1;
column = 2;

% plotting external & internal trajectory
subplot(row, column, 1);
Trajectory_plot = Smoothing_plots(Trajectory); % smoothing HD trajectory
Internal_HD_plot = Smoothing_plots(InternalR_HD); % smoothing HD representation
plot(Time + beginning, Internal_HD_plot, 'color', 'r', 'LineWidth', LineWidth);
set(gca, 'XLim', [beginning, beginning + time], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
ylabel('Accu. direction (deg)')
xlabel('Time (s)')
title('HD rep.')

% plotting the difference of HD
subplot(row, column, 2);
HD_difference = Internal_HD_plot - Trajectory_plot;
plot(Time + beginning, HD_difference, 'color', 'k', 'LineWidth', LineWidth);
set(gca, 'XLim', [beginning, beginning + time], 'YLim', [-180 180], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
hold on
plot([beginning, beginning + time], [0 0], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth / 2);
title('HD diff.')

set(gcf, 'unit', 'normalized', 'position', [0, 0, 1, 0.5]);
