% Weights snapshots for Fig 3

[X, Y] = meshgrid(Angle, 1 : N_abstract);
for kk = N_cue : N_cue
    figure('Color', 'w');
    
    for i = 1 : N_env
        W_retrieve = reshape(W_plot_temp(i + 1, :), N_abstract, []);
        W_plot = W_retrieve(:, ((kk - 1) * N_bin + 1) : (kk * N_bin));
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

        subplot(2, N_env, i)
        W_retrieve = reshape(W_plot_temp(i + 1, :), N_abstract, []);
        W_plot = W_retrieve(:, ((kk - 1) * N_bin + 1) : (kk * N_bin));
        for l = 1 : N_abstract
            W_sorted(l, :) = W_plot(W_RemapIndex(l), :);
        end
        contourf(X, Y, W_sorted, 'LineStyle', 'none');
        caxis([0 1]);
        set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [1, N_abstract], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        if i == 1
            title('Sn. I (400 s)')
        elseif i == 2
            title('Sn. II (800 s)')
        elseif i == 3
            title('Sn. I (1200 s)')
        end
        c = colorbar;
        
        subplot(2, N_env, i + N_env);
        W_retrieve = reshape(W_plot_temp(i + 1, :) - W_plot_temp(i, :), N_abstract, []);
        W_plot = W_retrieve(:, ((kk - 1) * N_bin + 1) : (kk * N_bin));
        for l = 1 : N_abstract
            W_sorted(l, :) = W_plot(W_RemapIndex(l), :);
        end
        contourf(X, Y, W_sorted, 'LineStyle', 'none');
        set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [1, N_abstract], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        if i == 1
            title('400 s - 0 s')
        elseif i == 2
            title('800 s - 400 s')
        elseif i == 3
            title('1200 s - 800 s')
        end
        caxis([-0.5 0.5]);
        c = colorbar;
    end
%     suptitle(['Cue No. ', num2str(kk)])
end

set(gcf, 'unit', 'normalized', 'position', [0, 0, 1, 1]);
