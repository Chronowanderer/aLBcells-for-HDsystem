% aLB-HD Learning

U_arep = zeros(2, N_abstract);
F_arep = zeros(2, N_abstract);
U_gRSC = zeros(2, N_bin);
F_gRSC = zeros(2, N_bin);
U_dRSC = zeros(2, N_bin);
F_dRSC = zeros(2, N_bin);
U_HD = zeros(2, N_bin);
F_HD = zeros(2, N_bin);
Con_a2d = zeros(1, T_len);
InternalR_HD = zeros(1, T_len);
F_visual = zeros(1, N_input);
Cue = zeros(1, N_cue);
Strength = zeros(1, N_cue);

Theta_ff = 1 - theta_intensity_ff / 2 + theta_intensity_ff / 2 * sind(theta_phase_ff + 360 * theta_frequency_ff * dt * (1 : T_len));
Theta_fb = 1 - theta_intensity_fb / 2 + theta_intensity_fb / 2 * sind(theta_phase_fb + 360 * theta_frequency_fb * dt * (1 : T_len));

for j = 1 : (T_len - 1)
    if j == (T_len - 1)
        F_HD_final = F_HD(1, :);
        F_HD_fmax = max(F_HD_final);
        F_HD_final = F_HD_final ./ F_HD_fmax .* 1;
        F_HD_fFWHM = sum(F_HD_final >= .5)
        continue;
    end
    
    present_time = beginning + j * dt;   
    present_time_temp = fix(present_time / Plagmatism_time);
    if Operation_Sheriruth
        present_env = mod(present_time_temp, N_env) + 1;
    else
        present_env = find(time_CueShifting >= present_time, 1);
    end
    
%     if Operation_Cyaegha && (find(time_CueShifting >= (beginning + (j + 1) * dt), 1) ~= find(time_CueShifting >= (beginning + j * dt), 1))  
%         HDsystem_Geburah_EinSofSof
%     end
    
    for k = 1 : N_cue       
        Cue(1, k) = AngularDiff(Cue_Init(present_env, k), Trajectory(j));
        Strength(1, k) = Strength_Init(present_env, k);
        F_visual_shift = circshift(F_visual_feature(k, :), [0 fix(Cue(1, k) / angle_gap)]);
        F_visual(1, ((k - 1) * N_bin + 1) : (k * N_bin)) = F_visual_shift .* Strength(1, k);
    end
    
    if j == 1
        % initializing weights: [output unit, input unit]
        W_visual = zeros(N_abstract, N_input);
        for theta = 1 : N_abstract
            W_visual(theta, :) = rand(1, N_input);
            W_visual0_tot = sqrt(sum(W_visual(theta, :) .^ 2));
            W_visual(theta, :) = W_visual(theta, :) ./ W_visual0_tot .* Wv_weight_scale;
        end
        W_visual(W_visual < 0.01) = 0;
        W_visual = sparse(W_visual);

        W_g2dRSC = eye(N_bin) * 1;
        W_arep2dRSC = ones(N_bin, N_abstract) / sqrt(N_abstract) * 1;
        W_dRSC2HD = eye(N_bin) * 1 - ones(N_bin, N_bin) / N_bin * U_dRSC2HD_i_gain_factor;
        W_HDring = zeros(1, N_bin);
        W_HD = zeros(N_bin, N_bin);
        
        Wnorm_V2A = zeros(time / 30, N_abstract * N_input);
        Wnorm_V2A(1, :) = reshape(W_visual, 1, []);
        Wnorm_a2d = zeros(time / 30, N_abstract * N_bin);
        Wnorm_a2d(1, :) = reshape(W_arep2dRSC, 1, []);
        Wnorm_g2d = zeros(time / 30, N_bin * N_bin);
        Wnorm_g2d(1, :) = reshape(W_g2dRSC, 1, []);
        
        U_HD(1, :) = circshift(U0, [0, fix(angluarrepresentation_phase / angle_gap)]) + noise_scale .* rand(1, N_bin);
        F_HD(1, :) = FiringRate_sigmoid_HD(U_HD(1, :), alpha_HD, beta_HD, gamma_HD);
        W_HDring(1, :) = W_stable + Gamma(j) .* dW_stable;
        InternalR_HD(j) = AngularMean(Angle, F_HD(1, :));
        
        U_gRSC(1, :) = U_HD2gRSC_gain_factor .* F_HD(1, :) * diag(ones(1, N_bin));
        F_gRSC(1, :) = FiringRate_sigmoid(U_gRSC(1, :), alpha_gRSC, beta_gRSC, gamma_gRSC);        
    end
    
    if (fix(present_time / 30) > fix((present_time - 1) / 30)) && (fix(present_time) < time)        
        Wnorm_V2A(fix(present_time / 30) + 1, :) = reshape(W_visual, 1, []);
        Wnorm_a2d(fix(present_time / 30) + 1, :) = reshape(W_arep2dRSC, 1, []);
        Wnorm_g2d(fix(present_time / 30) + 1, :) = reshape(W_g2dRSC, 1, []);
    end
    
    U_arep(2, :) = U_arep(1, :) + decay_rate_arep * (Theta_ff(j) * Uv_gain_factor * F_visual(1, :) * W_visual' ...
                        - U_arep(1, :) - inhibition_U_arep * F_arep(1, :) * Inhibition_U_arep');
    F_arep(2, :) = FiringRate_sigmoid_v(U_arep(2, :), alpha_arep, beta_arep, gamma_arep);
    learning_rate_visual = (present_time <= stop_learning_time) * lr_initial_rate_visual * exp(-lr_decay_rate_visual * j * dt);    
    W_visual = (1 - dr_weight_visual) * W_visual;
    if Operation_Midgard        
    % modified Oja's subspace algorithm
        W_visual = Learning_algorithms('mOSA', F_visual(1, :), F_arep(1, :), W_visual, learning_rate_visual, Theta_ff(j), Theta_fb(j));
    else    
    % Classic Hebbian rule      
        W_visual = Learning_algorithms('HL', F_visual(1, :), F_arep(1, :), W_visual, learning_rate_visual, 1, Wv_weight_scale);
    end    
    
    Con_a2d(j + 1) = max(U_arep2dRSC_gain_factor .* F_arep(1, :) * W_arep2dRSC');
    U_dRSC(2, :) = U_dRSC(1, :) + decay_rate_dRSC .* (0 - U_dRSC(1, :) - U_dRSC2dRSC_gain_factor .* F_dRSC(1, :) * ones(1, N_bin)' ./ N_bin + ...
    	U_arep2dRSC_gain_factor .* F_arep(1, :) * W_arep2dRSC' + U_g2dRSC_gain_factor .* F_gRSC(1, :) * W_g2dRSC');
    F_dRSC(2, :) = FiringRate_sigmoid(U_dRSC(1, :), alpha_dRSC, beta_dRSC, gamma_dRSC);        
    
    learning_rate_arep2dRSC = (present_time <= stop_learning_time) * lr_initial_rate_arep2dRSC * exp(-lr_decay_rate_arep2dRSC * j * dt);
    learning_rate_arep2dRSC_slow = (present_time <= stop_learning_time) * lr_initial_rate_arep2dRSC_slow * exp(-lr_decay_rate_arep2dRSC_slow * j * dt);
    learning_rate_arep2dRSC_vector = cat(2, repmat([learning_rate_arep2dRSC_slow], 1, N_bin / 2), repmat([learning_rate_arep2dRSC], 1, N_bin / 2));
    W_arep2dRSC = W_arep2dRSC + learning_rate_arep2dRSC_vector .* (F_dRSC(1, :)' * F_arep(1, :));
    Wa2d_total = sqrt(sum(W_arep2dRSC.^ 2, 2));
    Wa2d_total_metric = repmat(Wa2d_total,[1, N_abstract]);
    Wa2d_target = min(Wa2d_total, W_arep2dRSC_weight_scale);
    Wa2d_target_metric = repmat(Wa2d_target,[1, N_abstract]);
    W_arep2dRSC = W_arep2dRSC ./ Wa2d_total_metric .* Wa2d_target_metric;
    
    learning_rate_g2dRSC = (present_time <= stop_learning_time) * lr_initial_rate_g2dRSC * exp(-lr_decay_rate_g2dRSC * j * dt);    
    learning_rate_g2dRSC_slow = (present_time <= stop_learning_time) * lr_initial_rate_g2dRSC_slow * exp(-lr_decay_rate_g2dRSC_slow * j * dt);
    learning_rate_g2dRSC_vector = cat(2, repmat([learning_rate_g2dRSC_slow], 1, N_bin / 2), repmat([learning_rate_g2dRSC], 1, N_bin / 2));
    W_g2dRSC = W_g2dRSC + learning_rate_g2dRSC_vector .* (F_dRSC(1, :)' * F_gRSC(1, :));
    Wg2d_total = sqrt(sum(W_g2dRSC.^ 2, 2));
    Wg2d_total_metric = repmat(Wg2d_total,[1, N_bin]);
    Wg2d_target = min(Wg2d_total, W_g2dRSC_weight_scale);
    Wg2d_target_metric = repmat(Wg2d_target,[1, N_bin]);
    W_g2dRSC = W_g2dRSC ./ Wg2d_total_metric .* Wg2d_target_metric; 
    
    U_gRSC(2, :) = U_gRSC(1, :) + decay_rate_gRSC .* (0 - U_gRSC(1, :) + ...
        U_HD2gRSC_gain_factor .* F_HD(1, :) - U_gRSC2gRSC_gain_factor .* F_gRSC(1, :) * ones(1, N_bin)' ./ N_bin);
    F_gRSC(2, :) = FiringRate_sigmoid(U_gRSC(2, :), alpha_gRSC, beta_gRSC, gamma_gRSC);
    
    % HD attractor (see Zhang, 1996)
    if Operation_Cyaegha && (find(time_CueShifting >= (beginning + (j + 1) * dt), 1) ~= find(time_CueShifting >= (beginning + j * dt), 1))
        U_HD(1, :) = circshift(U0, [0, fix(Trajectory(j + 1) / angle_gap)]) + noise_scale .* rand(1, N_bin);
        F_HD(1, :) = FiringRate_sigmoid_HD(U_HD(1, :), alpha_HD, beta_HD, gamma_HD);
        InternalR_HD(j + 1) = AngularMean(Angle, F_HD(1, :));
    else
        W_HD(1, 1 : (N_bin / 2)) = W_HDring(1, (N_bin / 2 + 1) : N_bin);
        W_HD(1, (N_bin / 2 + 1) : N_bin) = W_HDring(1, 1 : (N_bin / 2));
        for k = 2 : N_bin
            W_HD(k, :) = circshift(W_HD(k - 1, :), [0 1]);
        end
    
    	% U_HD(2, :) = U_HD(1, :) + decay_rate_HD .* (0 - U_HD(1, :) + F_HD(1, :) * W_HD * U_HD_gain_factor); % blind the attractor
        U_HD(2, :) = U_HD(1, :) + decay_rate_HD .* (0 - U_HD(1, :) + F_HD(1, :) * W_HD * U_HD_gain_factor ...
                        + U_dRSC2HD_gain_factor * F_dRSC(1, :) * W_dRSC2HD + U_gRSC2HD_gain_factor .* F_gRSC(1, :));
        F_HD(2, :) = FiringRate_sigmoid_HD(U_HD(2, :), alpha_HD, beta_HD, gamma_HD);
        InternalR_HD(j + 1) = AngularMean(Angle, F_HD(2, :));
        W_HDring(1, :) = W_stable - W_stable_t + Gamma(j) .* (dW_stable - dW_stable_t);
    end

    if ~mod(j, 100)
        progress = j / (T_len - 1);
        remaining_time = toc(Stopwatch) / 100 * (T_len - j) / 60;
        if remaining_time >= 1
            waitbar(progress, hwait, ['Head Turning Progress ', num2str(progress * 100, '%.1f'), '% (Remaining ', num2str(remaining_time, '%.1f'), ' min)']);
        else
            waitbar(progress, hwait, ['Head Turning Progress ', num2str(progress * 100, '%.1f'), '% (Remaining ', num2str(remaining_time * 60, '%.0f'), ' sec)']);
        end
        Stopwatch = tic;
    end
    
    if (sum(F_HD(2, :) >= max(F_HD(2, :)) / 2) * angle_gap) > 120
        fprintf(['System Overflow at j = ', num2str(j), '!\n']);
        return
    end
    if (sum(F_HD(2, :) >= max(F_HD(2, :)) / 2) * angle_gap) < 10
        fprintf(['System Crashed at j = ', num2str(j), '!\n']);
        return
    end
    
    U_arep(1, :) = U_arep(2, :);
    F_arep(1, :) = F_arep(2, :);
    U_gRSC(1, :) = U_gRSC(2, :);
    F_gRSC(1, :) = F_gRSC(2, :);
    U_dRSC(1, :) = U_dRSC(2, :);
    F_dRSC(1, :) = F_dRSC(2, :);
    U_HD(1, :) = U_HD(2, :);
    F_HD(1, :) = F_HD(2, :);
    
end
