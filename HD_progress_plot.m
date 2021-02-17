% HD progress plot for the 20-minute simulation

figure('Color', 'w')
Trajectory_plot = zeros(1, T_len);
Internal_HD_plot = zeros(1, T_len);
HD_difference = zeros(1, T_len);

% Trajectory_plot = Smoothing_plots(Trajectory); % smoothing HD trajectory
% Internal_HD_plot = Smoothing_plots(InternalR_HD); % smoothing HD representation
% HD_difference = Internal_HD_plot - Trajectory_plot;

Trajectory_plot = Trajectory; % smoothing HD trajectory
Internal_HD_plot = InternalR_HD; % smoothing HD representation
for jjj = 1 : T_len
    HD_difference(jjj) = AngularDiff(Internal_HD_plot(jjj), Trajectory_plot(jjj));
end

plot([beginning, beginning + time], [0 0], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);
hold on

X = Time + beginning;
i = 1;
for j = 1 : T_len
    if (j == T_len) || (abs(HD_difference(j) - HD_difference(j + 1)) > 90)
        plot(X(i : j), HD_difference(i : j), 'color', 'k', 'LineWidth', LineWidth);
        hold on
        i = j + 1;
    end
end
set(gca, 'XLim', [beginning, beginning + time], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
set(gca, 'YLim', [-180 180]);

if (Operation_Sheriruth == 0) && (N_env <= 3)
    hold on
    plot([beginning + time / N_env, beginning + time / N_env], [-180 0], 'LineStyle', '--', 'Color', 'b', 'LineWidth', LineWidth);
%     hold on
%     plot([beginning + time / N_env * 2, beginning + time / N_env * 2], [-180 -130], 'LineStyle', '--', 'Color', 'b', 'LineWidth', LineWidth);
end

if (N_env == 2) || (N_env == 10)
    ylabel('HD Diff. (deg)')
end

set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.5, 0.5]);
