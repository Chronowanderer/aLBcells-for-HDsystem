% Head movement data processing

if Operation_Niflheim
    initiation = round(beginning / dt_exp);
    Trajectory_real = Data.HD((initiation + 1) : (initiation + T_len))';
    trajectory_0 = Trajectory_real(1);
    Trajectory_real(1) = 0;
    for j = 2 : T_len
        Trajectory_real(j) = AngularDiff(Trajectory_real(j), trajectory_0); % centralizing HD to the initial direction
        if abs(AngularDiff(Trajectory_real(j), Trajectory_real(j - 1))) > 30
            trajectory_0 = trajectory_0 + AngularDiff(Trajectory_real(j), Trajectory_real(j - 1));
            Trajectory_real(j) = Trajectory_real(j - 1);
        end
    end
else
    Trajectory_real(1) = 0;
    for j = 1 : (T_len - 1)
        current_moment = j * dt_exp;
        if current_moment > stop_learning_time % testing phase: continuously searching all directions once
            vlcty = 360 / (time - stop_learning_time);
        elseif mod(fix(current_moment), 2) % 1s uniform tuning preceding 1s no tuning as a cycle
            vlcty = vlcty_tuning;
        else
            vlcty = 0;
        end
        Trajectory_real(j + 1) = AngularDiff(Trajectory_real(j) + vlcty * dt_exp, 0);
    end
end
if Operation_Noatun
    PPT_HD = (rand(1, N_env) * 360 - 180) * Operation_Cyaegha;
    poisoned_HD = 0;
    sample_gap = round(dt_exp / dt);
    for j = 1 : (T_len - 1)
        pre_HD = AngularDiff(Trajectory_real(j) + poisoned_HD, 0);
        post_HD = AngularDiff(Trajectory_real(j + 1) + poisoned_HD, 0);
        while abs(pre_HD - post_HD) > 180
            if post_HD > pre_HD
                post_HD = post_HD - 360;
            else
                post_HD = post_HD + 360;
            end
        end
        for k = 1 : sample_gap
            current_index = (j - 1) * sample_gap + k;
            Trajectory(current_index) = AngularDiff(pre_HD + (post_HD - pre_HD) * 1.0 / sample_gap * (k - 1), 0);
        end
        if find(time_CueShifting >= (beginning + (j + 1) * dt_exp), 1) ~= find(time_CueShifting >= (beginning + j * dt_exp), 1)
        	poisoned_HD = PPT_HD(find(time_CueShifting >= (beginning + j * dt_exp), 1));
            % poisoned_HD = 0 - Trajectory_real(j + 1) + PPT_HD(find(time_CueShifting >= (beginning + j * dt_exp), 1));
        end
    end
    Trajectory(current_index + 1) = AngularDiff(post_HD, 0);
    Time = 0 : dt : time;
    T_len = length(Time);
else
    Trajectory = Trajectory_real;
end
