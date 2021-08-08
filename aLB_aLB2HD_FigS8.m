% Basic plots of generalization for Fig S8, tested in Figs 2 and 7
% When plotting a target row, comment the others in case of variable interference

clear

%% Plotting preparation
figure('Color', 'w')
LineWidth_FigS8 = 2;
FontSize_FigS8 = 12;
simulation_rows_length = 5;

%% Parameter dataset loading
aLB_Simulation_dataset = dir('Parameters/aLB_Simulation_Subject_*.mat');
aLB2HD_Simulation_dataset = dir('Parameters/aLB2HD_Simulation_Subject_*.mat');
simulation_dataset_length = length(aLB_Simulation_dataset);

for subject_FigS8 = 1 : simulation_dataset_length
    %% load Vis-aLB model parameters
    load(['Parameters/', aLB_Simulation_dataset(subject_FigS8).name])
    
    %% 1st row: HD trajectory at 11th min
    subplot(simulation_rows_length, simulation_dataset_length, 0 * simulation_dataset_length + subject_FigS8)
    Velocity = Differentiation_ascending(Trajectory, dt);
    Acceleration = Differentiation_ascending(Velocity, dt);
    Trajectory_plot = Smoothing_plots(Trajectory); % smoothing HD trajectory
    i = 1;
    X = Time + beginning;
    for j = 1 : (T_len - 1)
        if abs(Trajectory(j) - Trajectory(j + 1)) > 90
            plot(X(i : j), Trajectory(i : j), 'color', 'k', 'LineWidth', 1);
            hold on
            i = j + 1;
        end
    end
    set(gca, 'XLim', [600 660], 'YLim', [-180, 180], 'XTick', 600 : 20 : 660, 'YTick', -180 : 180 : 180);
    set(gca, 'LineWidth', LineWidth_FigS8, 'FontSize', FontSize_FigS8, 'FontWeight', 'bold');
    xlabel('Time (s)')
    if subject_FigS8 == 1
        ylabel('HD (deg)')
    end
    
    %% 2nd row: aLB cells in Fig 2
    subplot(simulation_rows_length, simulation_dataset_length, 1 * simulation_dataset_length + subject_FigS8)
    test_env = N_env;
    w_env = N_env + 1;
    firingrate_criterion_test = firingrate_criterion;
    Activated_unit = zeros(N_env, N_abstract);
    aLB_testing
    [X, Y] = meshgrid(Angle_bar, 1 : Bar_total_activated_unit);
    contourf(X, Y, Bar_MapSorted_AstRepresentation, 'LineStyle', 'none');
    set(gca, 'XLim', [-180 180 - bar_angle_gap], 'YLim', [1 Bar_total_activated_unit]);
    set(gca, 'LineWidth', LineWidth_FigS8, 'FontSize', FontSize_FigS8, 'FontWeight', 'bold');
    xlabel('HD (deg)')
    if subject_FigS8 == 1
        ylabel('aLB cells')
    end
    
    %% load aLB-HD model parameters
    load(['Parameters/', aLB2HD_Simulation_dataset(subject_FigS8).name])

    %% 3rd row: dRSC cells in Fig 7 (tested on Env.II)
    subplot(simulation_rows_length, simulation_dataset_length, 2 * simulation_dataset_length + subject_FigS8)
    condition_env = N_env;
    firingrate_criterion_test = firingrate_criterion;
    aLB2HD_testing
    [X, Y] = meshgrid(Angle_bar, Angle);
    contourf(X, Y, Bar_dRSC_firing, 'LineStyle', 'none');
    caxis([0 1])
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap])
    set(gca, 'LineWidth', LineWidth_FigS8, 'FontSize', FontSize_FigS8, 'FontWeight', 'bold');
    xlabel('HD (deg)')
    if subject_FigS8 == 1
        ylabel('dRSC cells')
    end
    
    %% 4th row: HD cells in Fig 7 (tested on Env.II)
    subplot(simulation_rows_length, simulation_dataset_length, 3 * simulation_dataset_length + subject_FigS8)
    contourf(X, Y, Bar_HD_firing, 'LineStyle', 'none');
    caxis([0 1])
    set(gca, 'XLim', [-180, 180 - bar_angle_gap], 'YLim', [-180, 180 - angle_gap])
    set(gca, 'LineWidth', LineWidth_FigS8, 'FontSize', FontSize_FigS8, 'FontWeight', 'bold');
    xlabel('HD (deg)')
    if subject_FigS8 == 1
        ylabel('HD cells')
    end
    
    %% 5th row: HD representations in Fig 7
    subplot(simulation_rows_length, simulation_dataset_length, 4 * simulation_dataset_length + subject_FigS8)
    Trajectory_plot = zeros(1, T_len);
    Internal_HD_plot = zeros(1, T_len);
    HD_difference = zeros(1, T_len);
    Trajectory_plot = Trajectory; % smoothing HD trajectory
    Internal_HD_plot = InternalR_HD; % smoothing HD representation
    for jjj = 1 : T_len
        HD_difference(jjj) = AngularDiff(Internal_HD_plot(jjj), Trajectory_plot(jjj));
    end
    plot([beginning, beginning + time], [0 0], 'LineStyle', ':', 'Color', 'r', 'LineWidth', LineWidth);
    hold on
    X = Time + beginning;
    i = 1;
    for j = 1 : T_len
        if (j == T_len) || (abs(HD_difference(j) - HD_difference(j + 1)) > 90)
            plot(X(i : j), HD_difference(i : j), 'color', 'k', 'LineWidth', LineWidth);
            hold on
            i = j + 1;
        end
    end    
    if (Operation_Sheriruth == 0) && (N_env <= 3)
        hold on
        plot([beginning + time / N_env, beginning + time / N_env], [-180 0], 'LineStyle', '--', 'Color', 'b', 'LineWidth', LineWidth);
    end
    set(gca, 'XLim', [beginning, beginning + time], 'XTick', 0 : 600 : 1200, 'YLim', [-180 180]);
    set(gca, 'LineWidth', LineWidth_FigS8, 'FontSize', FontSize_FigS8, 'FontWeight', 'bold');
    xlabel('Time (s)')
    if subject_FigS8 == 1
        ylabel('HD Diff. (deg)')
    end
    
end

set(gcf, 'unit', 'normalized', 'position', [0, 0, 1, 1]);
