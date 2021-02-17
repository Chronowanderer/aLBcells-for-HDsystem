% Cells during testing phase for Fig S7

% condition_env: [1, N_env] for testing in the corresponding single environment

condition_env = N_env;
firingrate_criterion_test = firingrate_criterion;

aLB2HD_testing % testing

figure('Color', 'w');

% aLB plots
subplot(2, 2, 1);
[X, Y] = meshgrid(Angle_bar, 1 : Bar_total_activated_unit);
contourf(X, Y, Bar_MapSorted_AstRepresentation, 'LineStyle', 'none');
caxis([0 1])
colorbar('off')
set(gca, 'XLim', [-180 180 - bar_angle_gap], 'YLim', [1 Bar_total_activated_unit], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
title('aLB cells')

subplot(2, 2, 2);
bar_abstract_selection = fix(Bar_total_activated_unit / 2);
Bar_selected_plotting = Bar_MapSorted_AstRepresentation(bar_abstract_selection, :);
plot(Angle_bar, Bar_selected_plotting, 'b', 'LineWidth', LineWidth + 1);
set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [0, 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
title(['#', num2str(bar_abstract_selection), '/', num2str(Bar_total_activated_unit)])
hold on
plot([0 0], [0 1], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);

%dRSC polts
subplot(2, 2, 3);
[X, Y] = meshgrid(Angle_bar, Angle);
contourf(X, Y, Bar_dRSC_firing, 'LineStyle', 'none');
caxis([0 1])
colorbar('off')
set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
title('dRSC cells')

subplot(2, 2, 4);
bar_selection = fix(N_bin / 2);
Bar_selected_plotting = Bar_dRSC_firing(bar_selection, :);
plot(Angle_bar, Bar_selected_plotting, 'b', 'LineWidth', LineWidth + 1);
set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [0, 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
title(['#', num2str(bar_selection), '/', num2str(N_bin)])
hold on
plot([0 0], [0 1], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);

set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.5, 0.5]);
