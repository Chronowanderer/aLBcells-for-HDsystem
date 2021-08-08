% aLB cells during testing phase with basic result plots for S1
figure('Color', 'w');

test_env = N_env;
w_env = N_env + 1;
firingrate_criterion_test = firingrate_criterion;
Activated_unit = zeros(N_env, N_abstract);
aLB_testing % testing

[X, Y] = meshgrid(Angle_bar, 1 : Bar_total_activated_unit);
contourf(X, Y, Bar_MapSorted_AstRepresentation, 'LineStyle', 'none');
set(gca, 'XLim', [-180 180 - bar_angle_gap], 'YLim', [1 Bar_total_activated_unit], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');

c = colorbar;
c.Label.FontSize = FontSize;
c.Label.FontWeight = 'bold';
set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.3, 0.3]);
