% Visual signals plotting for S9 Fig

Sc_str = {'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'};
row = 2;

Sc_str = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'};
row = 4;

figure('color', 'w')
Color = [1 0 0;
         0 0 1;
         0 1 0;
         1 1 0;
         1 0 1;
         0 1 1;];

for present_env = 1 : N_env
    subplot(row, fix(N_env / row), present_env)
    for k = 1 : N_cue
        if Strength_global(present_env, k) > 0
            kk = Cue_Perm(present_env, k);
            F_plot = circshift(F_visual_feature(kk, :), fix(Cue_Init(present_env, k) / angle_gap));
            
            % visual noise
            % visual_noise_intensity = 0;
            F_noise = 2 * rand(1, N_bin) - 1;
            tot_noise = sum(abs(F_noise));
            F_noise = F_noise ./ tot_noise * visual_noise_intensity * N_bin;
            F_plot = F_plot + F_noise;
            for i = 1 : length(F_visual_shift)
                if F_plot(i) < 0
                    F_plot(i) = 0;
                end
            end
            
            plot(Angle, F_plot, 'color', Color(k, :), 'LineWidth', LineWidth);
            hold on
        end
    end
    set(gca, 'XLim', [-180, 180 - angle_gap], 'YLim', [0 max(max(max(F_visual_feature)), 1)], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
    
    % title(['Sc.', num2str(present_env)]);
    title(Sc_str(present_env));
    if present_env > (N_env - fix(N_env / row))
        xlabel('Dir. (deg)')
    end
    if mod(present_env , fix(N_env / row)) == 1
        ylabel('\boldmath{$f_{Visual}$}', 'interpreter', 'latex')
    end
end
