% Plots of dRSC & HD cells during testing phase for Fig 8

if ~exist('Operation_Odin', 'var') || isempty(Operation_Odin)
    Operation_Odin = 0;
end

% condition_env: [1, N_env] for testing in the corresponding single environment
for condition_env = 1 : (N_env - 1) : N_env
    firingrate_criterion_test = firingrate_criterion;
    aLB2HD_testing % testing
    
    figure('Color', 'w');
    
    % dRSC plots
    subplot(2, 2, 1);
    [X, Y] = meshgrid(Angle_bar, Angle);
    contourf(X, Y, Bar_dRSC_firing, 'LineStyle', 'none');
    caxis([0 1])
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    ylabel('dRSC cells')
    title('\boldmath{$f_{dRSC}$}', 'interpreter', 'latex')
    
    subplot(2, 2, 2)
    bar_selection = fix(N_bin / 2);
    Bar_selected_plotting = Bar_dRSC_firing(bar_selection, :);
    plot(Angle_bar, Bar_selected_plotting, 'b', 'LineWidth', LineWidth + 1);
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [0, 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    title(['# ', num2str(bar_selection), '/', num2str(N_bin)])
    ylabel('\boldmath{$f_{dRSC}$}', 'interpreter', 'latex')
    hold on
    plot([0 0], [0 1], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);
    
    % HD attractor plots
    subplot(2, 2, 3);
    [X, Y] = meshgrid(Angle_bar, Angle);
    contourf(X, Y, Bar_HD_firing, 'LineStyle', 'none');
    caxis([0 1])
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    xlabel('HD (deg)')
    ylabel('HD cells')
    title('\boldmath{$f_{HD}$}', 'interpreter', 'latex')
    
    subplot(2, 2, 4);
    bar_selection = fix(N_bin / 2);
    Bar_selected_plotting = Bar_HD_firing(bar_selection, :);
    plot(Angle_bar, Bar_selected_plotting, 'b', 'LineWidth', LineWidth + 1);
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [0, 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    title(['# ', num2str(bar_selection), '/', num2str(N_bin)])
    xlabel('HD (deg)')
    ylabel('\boldmath{$f_{HD}$}', 'interpreter', 'latex')
    hold on
    plot([0 0], [0 1], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);
    
    set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.5, 0.5]);
    
    % Drifting results
    if condition_env == 1
        drift_list = zeros(1, N_bin);
        for k = 1 : N_bin
            drift_list(k) = find(Bar_HD_firing(k, :) == max(Bar_HD_firing(k, :)), 1) - k;
            if drift_list(k) < 0
                drift_list(k) = drift_list(k) + 360;
            end
        end
        mean_drift = mean(drift_list)
        std_drift = std(drift_list) / sqrt(N_bin)
    end
end
