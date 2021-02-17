% HD trajectory plot

figure('Color', 'w')

Velocity = Differentiation_ascending(Trajectory, dt);
Acceleration = Differentiation_ascending(Velocity, dt);
Trajectory_plot = Smoothing_plots(Trajectory); % smoothing HD trajectory
% trajectory_temp = Trajectory_plot(bar_beginning) - Trajectory_test(1);
% Trajectory_test_plot = Smoothing_plots(Trajectory_test + trajectory_temp); % smoothing HD trajectory

subplot(2, 1, 1)
i = 1;
X = Time + beginning;
for j = 1 : (T_len - 1)
    if abs(Trajectory(j) - Trajectory(j + 1)) > 90
        plot(X(i : j), Trajectory(i : j), 'color', 'k', 'LineWidth', 1);
        hold on
        i = j + 1;
    end
end
% plot(Time + beginning, Trajectory, 'color', 'k', 'LineWidth', 1);
% set(gca, 'XLim', [beginning, beginning + time], 'YLim', [-180, 180]);
set(gca, 'XLim', [600 660], 'YLim', [-180, 180], 'XTick', 600 : 20 : 660, 'YTick', -180 : 180 : 180);
set(gca, 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
ylabel('HD (deg)')

% subplot(3, 1, 2)
% plot(Time + beginning, Trajectory_plot, 'color', 'k', 'LineWidth', 2);
% set(gca, 'XLim', [beginning, beginning + time]);
% set(gca, 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
% ylabel('Accu. HD (deg)')

subplot(2, 1, 2)
plot(Time + beginning, Velocity, 'color', 'k', 'LineWidth', 1);
set(gca, 'XLim', [600 660], 'YLim', [-500, 1500], 'XTick', 600 : 20 : 660);
set(gca, 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
ylabel('Vel. (deg/s)')

set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.5, 1]);

% subplot(3, 2, 4)
% plot(Time + beginning, Acceleration, 'color', 'k', 'LineWidth', 1);
% set(gca, 'XLim', [beginning, beginning + time]);
% set(gca, 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
% ylabel('Accel. (deg/s^2)')
%
% subplot(3, 2, 5)
% plot(T_bar, Trajectory_test, 'color', [0.5 0.5 0.5], 'LineWidth', 3);
% set(gca, 'XLim', [start_testing_time, end_testing_time], 'YLim', [-180, 180]);
% set(gca, 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
% ylabel('HD (deg)')
% xlabel('Time (s)')
% 
% subplot(3, 2, 6)
% plot(T_bar, Trajectory_test_plot, 'color', [0.5 0.5 0.5], 'LineWidth', 3);
% set(gca, 'XLim', [start_testing_time, end_testing_time]);
% set(gca, 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
% ylabel('Accu. HD (deg)')
