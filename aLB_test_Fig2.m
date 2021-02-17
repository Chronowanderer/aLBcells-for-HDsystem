% aLB cells during testing phase for Fig 2  (with some plots simultaneously conducted)
figure('Color', 'w');

for w_env = (N_env + 1) : (N_env + 1)
    Activated_unit = zeros(N_env, N_abstract);
    for test_env = N_env : N_env
        firingrate_criterion_test = firingrate_criterion;
        aLB_testing % testing
        
        subplot(1, 2, 1);
        [X, Y] = meshgrid(Angle_bar, 1 : N_abstract);
        contourf(X, Y, Bar_arep_firing, 'LineStyle', 'none');
        set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [1, N_abstract], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        xlabel('HD (deg)')
        title('aLB cells')
        subplot(1, 2, 2);

        [X, Y] = meshgrid(Angle_bar, 1 : Bar_total_activated_unit);
        contourf(X, Y, Bar_MapSorted_AstRepresentation, 'LineStyle', 'none');
        set(gca, 'XLim', [-180 180 - bar_angle_gap], 'YLim', [1 Bar_total_activated_unit], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        c = colorbar;
        c.Label.FontSize = FontSize;
        c.Label.FontWeight = 'bold';
        title('Sorted aLB cells')
        set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.9, 0.5]);
    end
end
