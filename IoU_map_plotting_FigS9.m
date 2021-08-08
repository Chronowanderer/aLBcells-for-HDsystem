figure('Color', 'w');
subplot(1, 3, 1)
IoU_plot(IoU_map_local, Sc_str, LineWidth, FontSize / 2)
title('Intermediate', 'FontSize', FontSize) 
xlabel('Env.')
ylabel('Env.')

subplot(1, 3, 2)
IoU_plot(IoU_map_latest, Sc_str, LineWidth, FontSize / 2)
title('Final', 'FontSize', FontSize) 
xlabel('Env.')
ylabel('Env.')

subplot(1, 3, 3)
scatter(1 : N_env, IoU_map_comp, 100, 'g', 'filled');
set(gca, 'XLim', [1, N_env], 'YLim', [0, 1.05], 'LineWidth', LineWidth, 'FontSize', FontSize / 2, 'FontWeight', 'bold');
y = line([1, N_env], [0.8, 0.8]);
set(y, 'Color', 'r', 'LineWidth', LineWidth, 'linestyle', '--')
xticks(2 : 2 : N_env)
xticklabels(Sc_str(2 : 2 : N_env))
set(gcf, 'unit', 'normalized', 'position', [0, 0, 1, 0.5]);
title('Intermediate v.s. Final', 'FontSize', FontSize) 
xlabel('Env.')
ylabel('IoU')
