% aLB cells during testing phase for taking snapshots

firingrate_criterion_test = firingrate_criterion;
aLB_testing % testing

[X, Y] = meshgrid(Angle_bar, 1 : Bar_total_activated_unit);
contourf(X, Y, Bar_MapSorted_AstRepresentation, 'LineStyle', 'none');
set(gca, 'XLim', [-180 180 - bar_angle_gap], 'YLim', [1 Bar_total_activated_unit], 'FontSize', FontSize / 2, 'FontWeight', 'bold');
% set(gca, 'XTick', [], 'XColor', 'w', 'YTick', [], 'YColor', 'w');
title(['t = ', num2str((test_env - 1) * snapshot_interval), ' s'], 'FontSize', FontSize, 'FontWeight', 'bold');
c = colorbar;
c.Label.FontSize = FontSize / 2;
