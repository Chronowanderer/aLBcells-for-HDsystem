% Cells during testing phase for Fig S6E with examples of both
% WC-BD and BC-BD cells.

bar_selection_WCBD = 90; bar_selection_BCBD = 240;

if ~exist('Operation_Odin', 'var') || isempty(Operation_Odin)
    Operation_Odin = 0;
end

% condition_env: 
% [1, N_env] for testing in the corresponding single environment
for condition_env = 1 : N_env
    
    firingrate_criterion_test = firingrate_criterion;
    
    % HD bias for different environments
    HD_bias = 360.0 / N_env * (condition_env - 1);
    F_HD(1, :) = circshift(F_HD(1, :), [0 fix(HD_bias / angle_gap)]);
    U_HD(1, :) = circshift(U_HD(1, :), [0 fix(HD_bias / angle_gap)]);
    
    aLB2HD_testing % testing

    figure('Color', 'w');
    
    %dRSC polts
    subplot(1, 3, 1);
    [X, Y] = meshgrid(Angle_bar, Angle);
    contourf(X, Y, Bar_dRSC_firing, 'LineStyle', 'none');
    caxis([0 1])
    colorbar('off')
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    title('\boldmath{$f_{dRSC}$}', 'interpreter', 'latex')
    xlabel('HD (deg)')
    ylabel('dRSC cells')
    
    % BC-BD cell
    subplot(1, 3, 2);
    Bar_selected_plotting = Bar_dRSC_firing(bar_selection_BCBD, :);
    plot(Angle_bar, Bar_selected_plotting, 'b', 'LineWidth', LineWidth + 1);
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [0, 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    title(['#', num2str(bar_selection_BCBD), '/', num2str(N_bin)])
    xlabel('HD (deg)')
    ylabel('\boldmath{$f_{dRSC}$}', 'interpreter', 'latex')
    hold on
    plot([0 0], [0 1], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);
    
    % WC-BD cell
    subplot(1, 3, 3);
    Bar_selected_plotting = Bar_dRSC_firing(bar_selection_WCBD, :);
    plot(Angle_bar, Bar_selected_plotting, 'b', 'LineWidth', LineWidth + 1);
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [0, 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    title(['#', num2str(bar_selection_WCBD), '/', num2str(N_bin)])
    xlabel('HD (deg)')
    ylabel('\boldmath{$f_{dRSC}$}', 'interpreter', 'latex')
    hold on
    plot([0 0], [0 1], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);
    
    set(gcf, 'unit', 'normalized', 'position', [0, 0, 1, 0.3]);
end
