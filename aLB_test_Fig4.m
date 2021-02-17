% aLB cells during testing phase for Fig 4 (with some plots simultaneously conducted)
Sc_str = {'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'};

%% Pairwise test
bar_gap = 1;
bar_angle_gap = bar_gap * angle_gap;
Angle_bar = -180 : bar_angle_gap : (180 - bar_angle_gap);
bar_bin = length(Angle_bar);

Arep_firing = zeros(N_env, bar_bin * N_abstract);
Arep_RemapIndex = zeros(N_env, N_abstract);
Arep_total_activated_unit = zeros(1, N_env);
Arep_firing_latest = Arep_firing;
Arep_RemapIndex_latest = Arep_RemapIndex;
Arep_total_activated_unit_latest = Arep_total_activated_unit;

for condition = 1 : 2 % 1 for the first knowledge and 2 for the last knowledge
    figure('Color', 'w')
    Activated_unit = zeros(N_env, N_abstract);
    for test_env = 1 : N_env
        if condition == 1
            w_env = test_env + 1;
        elseif condition == 2
            w_env = N_env + 1;
        end
        
        subplot(2, fix(N_env / 2), test_env)
        firingrate_criterion_test = firingrate_criterion;
        aLB_testing % testing
        
        if condition == 1
            Arep_firing(test_env, :) = reshape(Bar_arep_firing, 1, []);
            Arep_RemapIndex(test_env, :) = bar_RemapIndex;
            Arep_total_activated_unit(test_env) = Bar_total_activated_unit;
        elseif condition == 2
            Arep_firing_latest(test_env, :) = reshape(Bar_arep_firing, 1, []);
            Arep_RemapIndex_latest(test_env, :) = bar_RemapIndex;
            Arep_total_activated_unit_latest(test_env) = Bar_total_activated_unit;
        end
        
        [X, Y] = meshgrid(Angle_bar, 1 : Bar_total_activated_unit);
        contourf(X, Y, Bar_MapSorted_AstRepresentation, 'LineStyle', 'none');
        set(gca, 'XLim', [-180 180 - bar_angle_gap], 'YLim', [1 Bar_total_activated_unit]);
        set(gca, 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        set(gca, 'XTick', [], 'XColor', 'w', 'YTick', [], 'YColor', 'w');
        title([Sc_str{test_env},' (', num2str(Bar_total_activated_unit), ')']);
    end
    
    % Heatmap of historic aLB cells
    figure('Color', 'w')
    heatmap(Activated_unit, [], Sc_str, [], 'FontSize', FontSize, 'TickFontSize', FontSize, 'Colormap', 'red', 'GridLines', '-');
    if condition == 1
        title('First');
        Historic_aLB = Activated_unit;
    elseif condition == 2
        title('Last');
    end
    
end

%% Heatmap difference of historic aLB cells
figure('Color', 'w');
heatmap(abs(Activated_unit - Historic_aLB), [], Sc_str, [], 'FontSize', FontSize, 'TickFontSize', FontSize, 'Colormap', 'red', 'GridLines', '-');
xlabel('aLB cells');
title('First v.s. Last');

%% IoU map preparation
IoU_map_local = zeros(N_env, N_env);
IoU_map_latest = zeros(N_env, N_env);
IoU_map_comp = zeros(1, N_env);
for test_env = 1 : N_env
    bar_RemapIndex = Arep_RemapIndex(test_env, :);
    Bar_total_activated_unit = Arep_total_activated_unit(test_env);
    for env_post = 1 : N_env
        bar_RemapIndex_II = Arep_RemapIndex(env_post, :);
        Bar_total_activated_unit_II = Arep_total_activated_unit(env_post);
        IoU_map_local(test_env, env_post) = IoU(bar_RemapIndex(1 : Bar_total_activated_unit), bar_RemapIndex_II(1 : Bar_total_activated_unit_II));
    end
    bar_RemapIndex = Arep_RemapIndex_latest(test_env, :);
    Bar_total_activated_unit = Arep_total_activated_unit_latest(test_env);
    for env_post = 1 : N_env
        bar_RemapIndex_II = Arep_RemapIndex_latest(env_post, :);
        Bar_total_activated_unit_II = Arep_total_activated_unit_latest(env_post);
        IoU_map_latest(test_env, env_post) = IoU(bar_RemapIndex(1 : Bar_total_activated_unit), bar_RemapIndex_II(1 : Bar_total_activated_unit_II));
    end
    bar_RemapIndex_II = Arep_RemapIndex(test_env, :);
    Bar_total_activated_unit_II = Arep_total_activated_unit(test_env);
    IoU_map_comp(1, test_env) = IoU(bar_RemapIndex(1 : Bar_total_activated_unit), bar_RemapIndex_II(1 : Bar_total_activated_unit_II));
end

%% IoU map plotting
figure('Color', 'w');
subplot(1, 3, 1)
IoU_plot(IoU_map_local, LineWidth, FontSize)
subplot(1, 3, 2)
IoU_plot(IoU_map_latest, LineWidth, FontSize)
subplot(1, 3, 3)
plot(1 : N_env, IoU_map_comp, 'k', 'LineWidth', LineWidth);
set(gca, 'XLim', [1, N_env], 'YLim', [0, 1.05], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
set(gcf, 'unit', 'normalized', 'position', [0, 0, 1, 0.5]);
