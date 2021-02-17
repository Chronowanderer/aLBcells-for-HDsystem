% Visual input settings

F_visual_temp = zeros(1, N_bin);
F_visual_feature = zeros(N_cue, N_bin);
if Operation_Nord
	for p = (0 - proximal_length / 2) : 1 : (proximal_length / 2)
    	F_visual_temp = F_visual_temp + vonmisespdf(Angle, p * angle_gap, precision_visual1);
    end
    F_visual_temp = F_visual_temp ./ length((0 - proximal_length / 2) : 1 : (proximal_length / 2));
else
    F_visual_temp = vonmisespdf(Angle, 0, precision_visual1);
end
Fv_max = max(F_visual_temp);
F_visual_temp = F_visual_temp ./ Fv_max .* Fv_max_factor; % basic visual firing rate
F_visual_mean = mean(F_visual_temp);
for k = 1 : N_cue
    if k == 3 % salient green cue in Figs 3C and 4A
        F_visual_feature(k, :) = vonmisespdf(Angle, 0, precision_visual1);
    elseif k == 1 % red cue
        F_visual_feature(k, :) = vonmisespdf(Angle, 90, precision_visual2) + vonmisespdf(Angle, -90, precision_visual2); % conflicting red cue in Fig 2A
        % F_visual_feature(k, :) = vonmisespdf(Angle, 0, precision_visual1); % unimodal red cue in Fig 4
        % F_visual_feature(k, :) = ones(1, N_bin) / N_bin; % uniform odor cue in S6C Fig
    elseif k == 2 % broad blue cue in Fig 2A
        for p = (0 - proximal_length / 2) : 1 : (proximal_length / 2)
            F_visual_feature(k, :) = F_visual_feature(k, :) + vonmisespdf(Angle, p, precision_visual2);
        end
        F_visual_feature(k, :) = F_visual_feature(k, :) / length((0 - proximal_length / 2) : 1 : (proximal_length / 2));
        % F_visual_feature(k, :) = ones(1, N_bin) / N_bin; % uniform odor cue in S6C Fig
    elseif k == 4 % noise in Fig 5A
        F_visual_feature(k, :) = rand(1, N_bin);
    end
    F_visual_feature_max = max(F_visual_feature(k, :));
    F_visual_feature(k, :) = Fv_max_factor / F_visual_feature_max * F_visual_feature(k, :);
    F_visual_feature_mean = mean(F_visual_feature(k, :));
    if Operation_Nidhogg    
        F_visual_feature(k, :) = F_visual_mean / F_visual_feature_mean * F_visual_feature(k, :);
    end
    if Operation_Urdar_brunnr
        F_visual_feature_mean = mean(F_visual_feature(k, :));
        F_visual_feature(k, :) = F_visual_feature(k, :) - F_visual_feature_mean;
    end
end
F_visual_feature_autocorr = sum((F_visual_feature') .^ 2) / size(F_visual_feature, 2);
F_visual_feature_norm = sqrt(F_visual_feature_autocorr);
