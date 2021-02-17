% aLB learning simulation - Testing

%% Parameters settings
Operation_Dynamic = 1;
if Operation_Dynamic
    decay_rate_arep_test = decay_rate_arep;
else
    decay_rate_arep_test = 1;
end

cycle = 10;
start_testing_time = time - 60 * 0;
end_testing_time = start_testing_time + 60 * 1;
vlcty_test = 360 * cycle / (end_testing_time - start_testing_time);

bar_gap = 1;
bar_beginning = fix(start_testing_time / dt);
T_bar = start_testing_time : dt : end_testing_time;
bar_angle_gap = bar_gap * angle_gap;
bar_time = length(T_bar);
Angle_bar = -180 : bar_angle_gap : (180 - bar_angle_gap);
bar_bin = length(Angle_bar);

Cue_global = Cue_Init;
Strength_global = Strength_Init;

%% Testing preparation
Trajectory_test = zeros(1, bar_time);
% Trajectory_test(1) = Trajectory(bar_beginning);
Trajectory_test(1) = HD_temp(w_env);
W_visual_test = reshape(W_plot_temp(w_env, :), N_abstract, []);
U_arep_test = U_arep_temp(w_env, :);
F_arep_test = F_arep_temp(w_env, :);
F_visual_test = zeros(1, N_input);
cue_test = zeros(1, N_cue);
strength_test = zeros(1, N_cue);
Bar_arep_firing = zeros(bar_bin, N_abstract);

%% Testing simulation
for jj = 1 : (bar_time - 1)
    Trajectory_test(jj + 1) = AngularDiff(Trajectory_test(jj) + vlcty_test * dt, 0);
    present_time = start_testing_time + jj * dt;
    U_arep_test_p = U_arep_test;
    F_arep_test_p = F_arep_test;
    F_visual_test_p = F_visual_test;
    
    if Operation_Jormungand && Operation_Jormungand_test && ...
            jumping_Jormungand && (~mod(j, fix(jumping_Jormungand / dt)))
        Cue_global(present_env, Operation_Jormungand) = 360 * rand(1) - 180;
    end
    
    for k = 1 : N_cue
        cue_test(k) = AngularDiff(Cue_global(test_env, k), Trajectory_test(jj));
        strength_test(k) = Strength_global(test_env, k);
        F_visual_shift = circshift(F_visual_feature(k, :), fix(cue_test(k) / angle_gap));
%         if k == 3
%             F_visual_shift = circshift(F_visual_feature(1, :), fix(cue_test(1) / angle_gap));
%         end
        if (k == Operation_Jormungand) && Operation_Jormungand_test
            F_visual_shift = circshift(F_visual_shift, fix(jj * dt * velocity_Jormungand / angle_gap));
        end
        if Operation_Valhalla
            F_visual_shift = F_visual_shift .* Visual_field;
        end
        F_visual_test(((k - 1) * N_bin + 1) : (k * N_bin)) = F_visual_shift * strength_test(k);
    end
    if Operation_Loki && (jj > 1)
        F_visual_test = F_visual_test_p + decay_rate_vSTM * (F_visual_test - F_visual_test_p);
    end
    
    if Operation_Bifrost && (jj > 100)
        for k = 1 : N_cue
            Featural_attention(k) = F_visual_test(((k - 1) * N_bin + 1) : (k * N_bin)) * F_arep_test';
        end
        Fa_sum = sum(Featural_attention);
        Featural_attention = Featural_attention / Fa_sum * total_featural_attention;
        for k = 1 : N_cue
            Neural_attention(((k - 1) * N_bin + 1) : (k * N_bin)) = Featural_attention(k);
        end
    end
    
    U_arep_test = U_arep_test_p + decay_rate_arep_test * ...
        (Theta_ff(jj + 1) * Uv_gain_factor * Neural_attention .* F_visual_test_p * W_visual_test' - ...
        U_arep_test_p - inhibition_U_arep * F_arep_test_p * Inhibition_U_arep');
    F_arep_test = FiringRate_sigmoid_v(U_arep_test_p, alpha_arep, beta_arep, gamma_arep);
    
    bar_present_HD = Trajectory_test(jj + 1);
    for l = 1 : bar_bin
        if (bar_present_HD >= Angle_bar(l)) && (bar_present_HD < (Angle_bar(l) + bar_angle_gap))
            Bar_arep_firing(l, :) = Bar_arep_firing(l, :) + F_arep_test;
            break
        end
    end
    if ((jj + bar_beginning) * dt < start_testing_time)
        bar(1 : N_abstract, F_arep_test, 'b');
        set(gca, 'XLim', [1, N_abstract], 'YLim', [0 1], 'LineWidth', LineWidth, 'FontSize', FontSize, 'FontWeight', 'bold');
        xlabel('Abstract Unit')
        ylabel('Abstract F after training')
        title(['HD = ', num2str(bar_present_HD), ' deg']);
        drawnow;
    end
end

%% Testing plots preparation
Bar_arep_firing = Bar_arep_firing' * dt / ((end_testing_time - start_testing_time) / (360 / bar_angle_gap));

Bar_total_activated_unit = 0;
while Bar_total_activated_unit < 2
    Bar_central_angle_index = zeros(1, N_abstract);
    for l = 1 : N_abstract
        if max(Bar_arep_firing(l, :)) > firingrate_criterion_test
            Bar_central_angle_index(l) = find(Bar_arep_firing(l, :) == max(Bar_arep_firing(l, :)), 1);
            % Bar_central_angle_index(l) = find(Bar_arep_firing(l, :) > firingrate_criterion_test, 1);
        else
            Bar_central_angle_index(l) = bar_bin + 1;
        end
    end
    [bar_RemapValue, bar_RemapIndex] = sort(Bar_central_angle_index);
    Bar_total_activated_unit = sum(Bar_central_angle_index <= bar_bin);
    if Bar_total_activated_unit < 2
        if firingrate_criterion_test == 0
            break
        end
        firingrate_criterion_test = 0;
    end
end

if Bar_total_activated_unit > 0
    Bar_MapSorted_AstRepresentation = zeros(Bar_total_activated_unit, bar_bin);
    Bar_FWHM = zeros(1, Bar_total_activated_unit);
    for l = 1 : Bar_total_activated_unit
        Bar_MapSorted_AstRepresentation(l, :) = Bar_arep_firing(bar_RemapIndex(l), :);
        Bar_FWHM(l) = sum(Bar_MapSorted_AstRepresentation(l, :) >= max(Bar_MapSorted_AstRepresentation(l, :)) / 2) * bar_angle_gap;
        Activated_unit(test_env, bar_RemapIndex(l)) = Activated_unit(test_env, bar_RemapIndex(l)) + 1;
    end
    bar_abstract_selection = fix(Bar_total_activated_unit / 2);
    Bar_selected_plotting = Bar_MapSorted_AstRepresentation(bar_abstract_selection, :);
end
