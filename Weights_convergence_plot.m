% Weight convergence plotting

figure('Color', 'w');
FontSize_temp = 30;
for k = 1 : (time / 30)
    W_norm(k) = norm(reshape(W_norm_temp(k, :), N_abstract, []) - W_visual);
    v_a = W_norm_temp(k, :);
    v_b = reshape(W_visual, 1, []);
    v_cov = cov(v_a, v_b);
    W_coef(k) = v_cov(1, 2) / (std(v_a) * std(v_b));
end
[AX, H1, H2] = plotyy(0 : 0.5 : (time / 60 - 0.5), W_norm, 0 : 0.5 : (time / 60 - 0.5), W_coef, 'plot');
xlabel('Training Time (min)')
set(get(AX(1), 'Ylabel'), 'String', '2-Norm Difference (*)', 'FontSize', FontSize_temp, 'FontWeight', 'bold')
set(get(AX(2), 'Ylabel'), 'String', 'Correlation Coefficient (O)', 'FontSize', FontSize_temp, 'FontWeight', 'bold')
set(H1, 'Color', 'k', 'Marker', '*', 'MarkerSize', FontSize_temp, 'LineStyle', '--')
set(H2, 'Color', 'k', 'Marker', 'o', 'MarkerSize', FontSize_temp, 'LineStyle', '--')
set(AX(1), 'XLim', [0, time / 60 - 1], 'Ycolor', 'k', 'LineWidth', LineWidth, 'FontSize', FontSize_temp, 'FontWeight', 'bold')
set(AX(2), 'XLim', [0, time / 60 - 1], 'Ycolor', 'k', 'LineWidth', LineWidth, 'FontSize', FontSize_temp, 'FontWeight', 'bold')
