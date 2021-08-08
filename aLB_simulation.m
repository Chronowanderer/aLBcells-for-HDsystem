% Vis-aLB Learning
% NB To change the learning algorithm, uncomment the correspondine code and
% comment the previous one after Operation_Fimbulvetr here.

Theta_ff = 1 - theta_intensity_ff / 2 + theta_intensity_ff / 2 * sin(deg2rad(theta_phase_ff) + 2 * pi * theta_frequency_ff * dt * (1 : T_len));
Theta_fb = 1 - theta_intensity_fb / 2 + theta_intensity_fb / 2 * sin(deg2rad(theta_phase_fb) + 2 * pi * theta_frequency_fb * dt * (1 : T_len));
U_arep = zeros(1, N_abstract);
F_arep = zeros(1, N_abstract);
F_visual = zeros(1, N_input);
cue = zeros(1, N_cue);
strength = zeros(1, N_cue);
Visual_field = vonmisespdf(Angle, 0, precision_visualfield);
visual_field_max = max(Visual_field);
Visual_field = Visual_field / visual_field_max;
Featural_attention = ones(1, N_cue) / N_cue * total_featural_attention;
for k = 1 : N_cue
    Neural_attention(((k - 1) * N_bin + 1) : (k * N_bin)) = Featural_attention(k);
end
previous_env = 0;
for j = 1 : (T_len - 1)
    present_time = beginning + j * dt;
    if Operation_Odin
        present_env = mod(fix(j * dt / duration_Odin), N_env) + 1;
    else
        if previous_env < N_env
            present_env = find(time_CueShifting >= present_time, 1);
        end
    end
    if Operation_Jormungand && jumping_Jormungand && (~mod(j, fix(jumping_Jormungand / dt)))
    	Cue_global(present_env, Operation_Jormungand) = 360 * rand(1) - 180;
    end
    U_arep_p = U_arep;
    F_arep_p = F_arep;
    F_visual_p = F_visual;
    
    for k = 1 : N_cue       
        cue(k) = AngularDiff(Cue_global(present_env, k), Trajectory(j));
        strength(k) = Strength_global(present_env, k);
        F_visual_shift = circshift(F_visual_feature(k, :), fix(cue(k) / angle_gap));
        if k == Operation_Jormungand
            F_visual_shift = circshift(F_visual_shift, fix(j * dt * velocity_Jormungand / angle_gap));
        end
        if Operation_Valhalla
            F_visual_shift = F_visual_shift .* Visual_field;
        end
        
        % visual noise
        F_noise = 2 * rand(1, N_bin) - 1;
        tot_noise = sum(abs(F_noise));
        F_noise = F_noise ./ tot_noise * visual_noise_intensity * N_bin;
        F_visual_shift = F_visual_shift + F_noise;
        for i = 1 : length(F_visual_shift)
            if F_visual_shift(i) < 0
                F_visual_shift(i) = 0;
            end
        end
        
        F_visual(((k - 1) * N_bin + 1) : (k * N_bin)) = F_visual_shift * strength(k);
    end        
    if Operation_Loki && (j > 1)
    	F_visual = F_visual_p + decay_rate_vSTM * (F_visual - F_visual_p);
    end
    
    if j == 1
        % initializing weights: [output unit, input unit]
        W_visual = zeros(N_abstract, N_input);
        for theta = 1 : N_abstract
            W_visual(theta, :) = rand(1, N_input);
            W_visual_tot = sqrt(sum(W_visual(theta, :) .^ 2));
            W_visual(theta, :) = W_visual(theta, :) / W_visual_tot * Wv_weight_scale;
        end
        W_visual(W_visual < 0.01) = 0;
        W_visual = sparse(W_visual);
        
        HD_temp = zeros(1, N_env + 1);
        U_arep_temp = zeros(N_env + 1, N_abstract);
        F_arep_temp = zeros(N_env + 1, N_abstract);
        W_plot_temp = zeros(N_env + 1, N_abstract * N_input);
        W_norm_temp = zeros(time / 30, N_abstract * N_input);
        W_norm_temp(1, :) = reshape(W_visual, 1, []);
    end
    
    if Operation_Bifrost && (j > 100)
        for k = 1 : N_cue
            Featural_attention(k) = F_visual(((k - 1) * N_bin + 1) : (k * N_bin)) * F_arep';
        end
        Fa_sum = sum(Featural_attention);
        Featural_attention = Featural_attention / Fa_sum * total_featural_attention;
        for k = 1 : N_cue
            Neural_attention(((k - 1) * N_bin + 1) : (k * N_bin)) = Featural_attention(k);
        end
    end
    
    if ~Operation_Odin
        if present_env > previous_env
            HD_temp(present_env) = Trajectory(j);
            U_arep_temp(present_env, :) = U_arep;
            F_arep_temp(present_env, :) = F_arep;
            W_plot_temp(present_env, :) = reshape(W_visual, 1, []);
            previous_env = present_env;
            
            if present_time <= beginning + Operation_Zwerge
                if present_env == 1
                    figure('Color', 'w')
                end
                subplot(4, N_env / 4, present_env)
                test_env = present_env; 
                w_env = present_env; 
                aLB_test_snapshots
            end
            
        elseif present_time == time
            HD_temp(present_env + 1) = Trajectory(j);
            U_arep_temp(present_env + 1, :) = U_arep;
            F_arep_temp(present_env + 1, :) = F_arep;
            W_plot_temp(present_env + 1, :) = reshape(W_visual, 1, []);
        end
    end
    if (fix(present_time / 30) > fix((present_time - 1) / 30)) && (fix(present_time) < time)
        W_norm_temp(fix(present_time / 30) + 1, :) = reshape(W_visual, 1, []);
    end
    
    U_arep = U_arep_p + decay_rate_arep * ...
        (Theta_ff(j) * Uv_gain_factor * Neural_attention .* F_visual_p * W_visual' - U_arep_p ...
        - inhibition_U_arep * F_arep_p * Inhibition_U_arep');
    F_arep = FiringRate_sigmoid_v(U_arep, alpha_arep, beta_arep, gamma_arep);
    learning_rate_visual = (present_time <= stop_learning_time) * lr_initial_rate_visual * exp(-lr_decay_rate_visual * j * dt);
   
    W_visual = (1 - dr_weight_visual) * W_visual; 
    
    % Change learning algorithms here (see Learning_algorithms.m)
    if Operation_Fimbulvetr
           
    % modified Oja's subspace algorithm
        W_visual = Learning_algorithms('mOSA', F_visual_p, F_arep, W_visual, learning_rate_visual, Theta_ff(j), Theta_fb(j));
    
    % original Oja's subspace algorithm
%         W_visual = Learning_algorithms('OSA', F_visual_p, F_arep, W_visual, learning_rate_visual, Theta_ff(j), Theta_fb(j));
        
    % Oja's single neuron algorithm
%         W_visual = Learning_algorithms('sOSA', F_visual_p, F_arep, W_visual, learning_rate_visual);
        
    % STDP
%         lr_LTD = 1e-1;
%         lr_LTP = 1e-3;
%         W_visual = Learning_algorithms('STDP', F_visual_p, F_arep, W_visual, 1, lr_LTP, lr_LTD);

    % Sanger's rule (GHA)
%         W_visual = Learning_algorithms('GHA', F_visual_p, F_arep, W_visual, learning_rate_visual);

    else
    % Classic Hebbian rule    
        W_visual = Learning_algorithms('HL', F_visual_p, F_arep, W_visual, learning_rate_visual, 1, Wv_weight_scale);    
            
    % Hebbian covariance rule
%         if j == 1
%             mean_post = zeros(1, N_abstract);
%             mean_pre = zeros(1, N_input);
%         end
%         mean_post = mean_post + decay_rate_interval * (F_arep - mean_post);
%         mean_pre = mean_pre + decay_rate_interval * (F_visual - mean_pre);
%         W_visual = Learning_algorithms('HCL', F_visual_p, F_arep, W_visual, learning_rate_visual, mean_pre, mean_post);
        
    % BCM
%         if j == 1
%             threshold_M = zeros(1, N_abstract);
%         end
%         threshold_M = threshold_M + decay_rate_interval * (F_arep .^ 2 - threshold_M);
%         W_visual = Learning_algorithms('BCM', F_visual_p, F_arep, W_visual, learning_rate_visual, beta_arep, threshold_M);    
    
    % Competitive learning
%        W_visual = Learning_algorithms('Competitive', F_visual_p, F_arep, W_visual, learning_rate_visual);    
    end
    
    if ~mod(j, 1000)
        progress = j / (T_len - 1);
        remaining_time = toc(Stopwatch) / 1000 * (T_len - j) / 60;
        if remaining_time >= 1
            waitbar(progress, hwait, ['Abstract Learning Progress ', num2str(progress * 100, '%.1f'), '% (Remaining ', num2str(remaining_time, '%.1f'), ' min)']);
        else
            waitbar(progress, hwait, ['Abstract Learning Progress ', num2str(progress * 100, '%.1f'), '% (Remaining ', num2str(remaining_time * 60, '%.0f'), ' sec)']);
        end
        Stopwatch = tic;
    end
end
