% Capacity varification for Vis-aLB model (S9, S11, S12 Figs in the paper).

clear

%% Plot settings
LineWidth = 3;
FontSize = 28;

%% OPERATION settings (1 for switching on & 0 for switching off, unless specified)
% Fixed operations
Operation_Niflheim = 1; % Importing realistic head turning
Operation_Noatun = 1; % Extending HD trajectory with linearity
Operation_Nord = 0; % Incoming proximal cues (waiting for renewing...)
Operation_Nidhogg = 1; % Scaling on visual input signals
Operation_Urdar_brunnr = 0; % Centralisation on visual input signals
Operation_Ratatoskr = 0; % 'Quite' perfect HD weights
Operation_Cyaegha = 0; % random initial HD in each env.
Operation_Loki = 0; % Visual STM instead of visual PM
Operation_Valhalla = 0; % Restricted visual field
Operation_Bifrost = 0; % Featural attention
Operation_Odin = 0; % Multi-environment wandering
    duration_Odin = 10; % Single-environment wandering time (s)

% Tune the following operations for different simulations among Figs 1-4 & S1-S5 Figs

% Containing feedback transmission 
Operation_Fimbulvetr = 1; % 1 for OSA and 0 for others
% Change learning algorithms in aLB_simulation.m For S1 Fig

% [1, N_cue] pointing the specific moving cue, 0 for disabled 
Operation_Jormungand = 0; % blue cue (i.e. 2) for Figs 3A-B
    % Moving velocily (deg/s) 
    velocity_Jormungand = 0; % 90 for Fig 3A
    % Duration after randomly jumping (s), 0 for disabled 
    jumping_Jormungand = 0; % 10 for Fig 3B

% ONLY use the following operations for single-environemnt simulation (i.e. Fig 2)!
% Duration for taking aLB testing snapshots at the beginning (s), 0 for disabled 
Operation_Zwerge = 0; % 300 for S2 Fig
    % Temporal interval of snapshots (s)
    snapshot_interval = 0; % 15 for S2 Fig

%% Simulation settings

% selecting HD trajectory data
file = dir('RealData_CIRC_Manson/RealData_CIRC_Manson*.mat');
subject = 1;
Data = load(['RealData_CIRC_Manson/', file(subject).name]);

% parameters file setting
save_data = ['Parameters/Fig_', 'S9_temp'];

% default parameters loading
Default_parameters % Change the following parameters for different simulations in the paper

% Timing
time = 60 * 40; % Duraion time (s) (Experimental Duration: 40 mins)
beginning = 60 * 0; % Initial time point (s)
stop_learning_time = beginning + time; % End time (s) for learning
Time = 0 : dt_exp : time; % Time
T_len = length(Time); % Number of time point

% number of subsequent environments
N_env = 20; % S9 Fig
% N_env = 10; % S12 Fig

% number of cue features in S9 Fig
N_cue = 6; % total number of cues across all environments
N_vcue = 3; % number of visible cues in each local environment

% Number of visual input layer unit
N_input = N_cue * N_bin;

% Time point (s) for shifting cues
time_CueShifting = beginning + (time / N_env) : (time / N_env) : time;
% if taking aLB snapshots (only use this for single-environmnet simulation here!)
if Operation_Zwerge > 0
    N_env = fix(Operation_Zwerge / snapshot_interval); % please ensure Cue_Init is defined as single environment
    time_CueShifting = beginning + snapshot_interval : snapshot_interval : Operation_Zwerge;
end

% angular position (deg) of the center of cues (centralized at initial HD trajectory)
% Environmental dimension: N_env * N_cue
    % S9 Fig
    % Visual cue location randomised
    Cue_Init = rand(N_env, N_cue) * 360 - 180;

    % Visual firing patterns
    Cue_Perm = zeros(N_env, N_cue);
    for i = 1 : N_env
        Cue_Perm(i, :) = 1 : N_cue;
    end
    
    % Visible local cues as different as possible
    perm = zeros(1, N_cue);
    perm(1 : N_vcue) = ones(1, N_vcue);
    Perms = unique(perms(perm), 'rows');
    n_Perms = length(Perms);
    Strength_Init = zeros(N_env, N_cue);
    for i = 1 : fix(N_env / n_Perms)
        rPerms = randperm(n_Perms);
        Strength_Init(((i - 1) * n_Perms + 1) : (i * n_Perms), :) = Perms(rPerms, :);
    end
    i = fix(N_env / n_Perms);
    if N_env - i * n_Perms > 0
        rPerms = randperm(n_Perms);
        Strength_Init((i * n_Perms + 1) : N_env, :) = Perms(rPerms(1 : (N_env - i * n_Perms)), :);
    end

% S11 Fig (for N_aLB as 360 or 720): load from S9 Fig
% load('Parameters/Fig_S9', 'Cue_Init', 'Cue_Perm', 'Strength_Init')

% global cue settings
Cue_global = Cue_Init;
Strength_global = Strength_Init;

% Parameter rectification
N_abstract = 1080; % 360/720/1080
Uv_gain_factor = 10;
lr_initial_rate_visual = 1e-4;

% interinhibition matrix of abstract representation - change for S1A Fig
Inhibition_U_arep = (ones(N_abstract) - eye(N_abstract)) / sqrt(N_abstract - 1); % lateral inhibition
%Inhibition_U_arep = ones(N_abstract) / sqrt(N_abstract); % global inhibition for S1A Fig
%Inhibition_U_arep = zeros(N_abstract); % no inhibition for S1A Fig

% minimun firing rate (scaled) for enabling to encode the abstract representation 
firingrate_criterion = .5; % will later plot all aLB cells if no one exceeds the threshold

% visual noise intensity for S11 Fig (0 otherwise)
% visual_noise_intensity = 0.05;

%% HD trajectory settings
HD_trajectory_FigS9

%% Visual input settings
% For Fig 4, choose Line 21 for feature 1 in Visual_inputs.m
% For others, choose Line 20 for feature 1 and Line 27 for feature 2 in Visual_inputs.m
Visual_inputs_FigS9
F_visual_feature_norm

%% Simulation - training
[X, Y] = meshgrid(Angle, 1 : N_abstract);
hwait = waitbar(0, 'aLB Learning Progress 0%');
elapsed_time = 0;
Stopwatch = tic;
% Change learning algorithms before running aLB_simulation.m for S1 Fig
aLB_simulation_FigS9 % Training
close(hwait);

%% Save data from training
save(save_data)

%% TESTING SECTION STARTS HERE

%% Load training results (if saved) to do the test
% load('Parameters/Fig_S9') 

%% General plotting
HD_trajectory_plot
Visual_inputs_plot_FigS9
Weights_convergence_plot
Weights_aLB_plot

%% Simulation - testing
% Note testing plots are simultaneously conducted during the testing phase.
aLB_test_FigS9
