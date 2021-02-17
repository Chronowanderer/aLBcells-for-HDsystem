% Plotting vis-aLB weights

row_2 = 1;
column_2 = N_cue;
figure('Color', 'w');
% W_visual = reshape(W_plot_temp(N_env + 1, :), N_abstract, []);
for cue_selection = 1 : column_2
    if N_cue >= cue_selection
%         subplot(row_2, column_2, cue_selection);
%         F_plot = circshift(F_visual_feature(cue_selection, :), fix(Cue_global(1, cue_selection) / angle_gap));
%         plot(Angle, F_plot, 'color', Color(cue_selection, :), 'LineWidth', LineWidth);
%         Legend = {['Cue', num2str(cue_selection)]};
%         lgd = legend(Legend, 'Location', 'northoutside', 'FontSize', FontSize, 'FontWeight', 'bold');
%         legend('boxoff')
%         set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [0 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        
        W_plot = W_visual(:, ((cue_selection - 1) * N_bin + 1) : (cue_selection * N_bin));
        [X, Y] = meshgrid(Angle, 1 : N_abstract);
%         
%         subplot(row_2, column_2, cue_selection + column_2);
%         z_label = ['Final weights for the cue ', num2str(cue_selection)];
% %         s = surf(X, Y, W_plot, 'FaceAlpha', .75);
% %         s.EdgeColor = 'none';
% %         zlabel(z_label)
% %         grid off
%         [X, Y] = meshgrid(Angle, 1 : N_abstract);
%         contourf(X, Y, W_plot, 'LineStyle', 'none');
%         set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [1, N_abstract], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
%         c = colorbar;
%         c.Label.FontSize = FontSize;
%         c.Label.FontWeight = 'bold';
%         c.Label.String = z_label;
        
        subplot(row_2, column_2, cue_selection);
        W_plot_index = zeros(1, N_abstract);
        W_plot_max = max(max(W_plot));
        W_plot_min = min(min(W_plot));
        W_plot_criteria = W_plot_min + (W_plot_max - W_plot_min) * 0;
        for l = 1 : N_abstract
            W_plot_index_temp = find(W_plot(l, :) == max(W_plot(l, :)), 1);
            if max(W_plot(l, :)) > W_plot_criteria
                W_plot_index(l) = W_plot_index_temp;
            else
                W_plot_index(l) = N_bin + 1 + W_plot_index_temp;
            end
        end
        [W_RemapValue, W_RemapIndex] = sort(W_plot_index);
        W_sorted = zeros(N_abstract, N_bin);
        for l = 1 : N_abstract
            W_sorted(l, :) = W_plot(W_RemapIndex(l), :);
        end
        contourf(X, Y, W_sorted, 'LineStyle', 'none');
        set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [1, N_abstract], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        if cue_selection == 1
            xlabel('Red ego. vis. cells')
            ylabel('aLB cells')
        elseif cue_selection == 2
            xlabel('Blue ego. vis. cells')
        end
        c = colorbar;
        c.Label.FontSize = FontSize;
        c.Label.FontWeight = 'bold';
        set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.6, 0.5]);
    end
end
