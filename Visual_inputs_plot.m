% Visual signals plotting

figure('color', 'w')
Color = [1 0 0;
         0 0 1;
         0 1 0;
         0.5 0.5 0.5;];
for k = 1 : N_cue
    F_plot = circshift(F_visual_feature(k, :), fix(Cue_Init(1, k) / angle_gap));
%     if k == 3
%         F_plot = F_visual_feature(k, :);
%     end
    if k == 4
        plot(Angle, F_plot, 'color', Color(k, :), 'LineWidth', 1);
    else
        plot(Angle, F_plot, 'color', Color(k, :), 'LineWidth', LineWidth);
    end
    hold on
end
set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [0 max(max(F_visual_feature))], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
xlabel('Ego. Direction (Deg)')
set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.3, 0.3]);
