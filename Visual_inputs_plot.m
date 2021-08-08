% Visual signals plotting

figure('color', 'w')
Color = [1 0 0;
         0 0 1;
         0 1 0;
         0.5 0.5 0.5;];
for k = 1 : N_cue
    F_plot = circshift(F_visual_feature(k, :), fix(Cue_Init(1, k) / angle_gap));
    
    % visual noise
    visual_noise_intensity = 0;
    F_noise = 2 * rand(1, N_bin) - 1;
    tot_noise = sum(abs(F_noise));
    F_noise = F_noise ./ tot_noise * visual_noise_intensity * N_bin;
    F_plot = F_plot + F_noise;
    for i = 1 : length(F_visual_shift)
        if F_plot(i) < 0
            F_plot(i) = 0;
        end
    end
    
    if k == 4
        plot(Angle, F_plot, 'color', Color(k, :), 'LineWidth', 1);
    else
        plot(Angle, F_plot, 'color', Color(k, :), 'LineWidth', LineWidth);
    end
    hold on
end
set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [0 max(max(max(F_visual_feature)), 1)], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
xlabel('Ego. Direction (Deg)')
ylabel('\boldmath{$f_{Visual}$}', 'interpreter', 'latex')
set(gcf, 'unit', 'normalized', 'position', [0, 0, 0.3, 0.3]);
