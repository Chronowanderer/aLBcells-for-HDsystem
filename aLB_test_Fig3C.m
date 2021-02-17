% aLB cells during testing phase for Fig 3C (with some plots simultaneously conducted)
for w_env = N_env : (N_env + 1)
    Activated_unit = zeros(N_env, N_abstract);
    
    for test_env = 1 : N_env
        figure('Color', 'w');
        firingrate_criterion_test = firingrate_criterion;
        aLB_testing % testing
        
        [X, Y] = meshgrid(Angle_bar, 1 : Bar_total_activated_unit);
        contourf(X, Y, Bar_MapSorted_AstRepresentation, 'LineStyle', 'none');
        set(gca, 'XLim', [-180 180 - bar_angle_gap], 'YLim', [1 Bar_total_activated_unit], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        c = colorbar;
        c.Label.FontSize = FontSize;
        c.Label.FontWeight = 'bold';
        set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.3, 0.3]);
    end
    
    % Heatmap of historic aLB cells
    figure('Color', 'w')
    heatmap(Activated_unit, [], {'Sc. I', 'Sc. II', 'Green'}, [], 'FontSize', FontSize, 'TickFontSize', FontSize, 'Colormap', 'red', 'GridLines', '-');
    if w_env == N_env
        title('800 s');
        Historic_aLB = Activated_unit;
    elseif w_env == N_env + 1
        title('1200 s');
    end
end

% Heatmap Difference of historic aLB cells
figure('Color', 'w');
heatmap(abs(Activated_unit - Historic_aLB), [], {'Sc. I', 'Sc. II', 'Green'}, [], 'FontSize', FontSize, 'TickFontSize', FontSize, 'Colormap', 'red', 'GridLines', '-');
xlabel('aLB cells');
title('800s v.s. 1200s');

% Weights snapshots
aLB_test_weights
