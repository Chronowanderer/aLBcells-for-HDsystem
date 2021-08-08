% Main code for Vis-aLB model (Figs 1-4 & S1-S5, S10 Figs in the paper).
% Change operations and parameters to output different figures in the paper
% (see comments).

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

% Tune the following operations for different simulations among Figs 1-4 & S1-S5, S10 Figs

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
save_data = ['Parameters/Fig_', 'temp'];

% default parameters loading
Default_parameters % Change the following parameters for different simulations in the paper

% Timing
time = 60 * 20; % Duraion time (s) (Experimental Duration: 20 mins)
beginning = 60 * 0; % Initial time point (s)
stop_learning_time = beginning + time; % End time (s) for learning
Time = 0 : dt_exp : time; % Time
T_len = length(Time); % Number of time point

% number of subsequent environments
% N_env = 1; % Figs 2, 3A-B; S1-S2 Figs
% N_env = 3; % Fig 3C; S3-4 Figs
N_env = 10; % Fig 4; S5, S10 Figs

% number of cue features
% N_cue = 2; % Figs 2, 3A-B; S1-S2 Figs
N_cue = 3; % Figs 3C, 4; S3-5, S10 Figs

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
    % Figs 2, 3A-B; S1-S2 Figs
%     Cue_Init = ones(N_env, N_cue) * 360 - 360; % Angular position of the center
%     Strength_Init = ones(N_env, N_cue); % Strength
    
    % Fig 3C; S3-4 Figs
%     Cue_Init = ones(N_env, 1) * [0 0 180];
%     Strength_Init = [1 1 0; 1 1 1; 1 1 0;];
    
    % Fig 4; S5, S10 Figs
    Cue_Init = cat(2, ones(N_env, N_cue - 1) .* zeros(1, N_cue - 1), 0 + (-180 : (360 / N_env) : (180 - 360 / N_env))');
    Strength_Init = ones(N_env, N_cue);

% global cue settings
Cue_global = Cue_Init;
Strength_global = Strength_Init;

% interinhibition matrix of abstract representation - change for S1A Fig
Inhibition_U_arep = (ones(N_abstract) - eye(N_abstract)) / sqrt(N_abstract - 1); % lateral inhibition
%Inhibition_U_arep = ones(N_abstract) / sqrt(N_abstract); % global inhibition for S1A Fig
%Inhibition_U_arep = zeros(N_abstract); % no inhibition for S1A Fig

% minimun firing rate (scaled) for enabling to encode the abstract representation 
firingrate_criterion = .5; % will later plot all aLB cells if no one exceeds the threshold

% visual noise intensity for S10 Fig (0 otherwise)
% visual_noise_intensity = 0.05;

%% HD trajectory settings
HD_trajectory

%% Visual input settings
% For Fig 4, choose Line 21 for feature 1 in Visual_inputs.m
% For others, choose Line 20 for feature 1 and Line 27 for feature 2 in Visual_inputs.m
Visual_inputs
F_visual_feature_norm

%% Simulation - training
[X, Y] = meshgrid(Angle, 1 : N_abstract);
hwait = waitbar(0, 'aLB Learning Progress 0%');
elapsed_time = 0;
Stopwatch = tic;
% Change learning algorithms before running aLB_simulation.m for S1 Fig
aLB_simulation % Training
close(hwait);

%% Save data from training
save(save_data)

%% TESTING SECTION STARTS HERE

%% Load training results (if saved) to do the test
% load('Parameters/Fig_S4') 

%% General plotting
HD_trajectory_plot
Visual_inputs_plot
Weights_convergence_plot
Weights_aLB_plot

%% Simulation - testing
% Note testing plots are simultaneously conducted during the testing phase.
% Run one of them every time, and remember to setup parameters and
% operations before running.

% Single plot of aLB representations for single-environment testing (e.g. S1 Fig)
% aLB_test_plot

% Figs 2; S2 Fig
% aLB_test_Fig2

% Figs 3A-B
% Operation_Jormungand_test = 0; % disable (0, default) / enable (1) the moving cue during testing phase
% aLB_test_Fig3AB

% Fig 3C; S3-4 Figs
% Strength_Init = [1 1 0; 1 1 1; 0 0 1;]; % For testing scenes
% aLB_test_Fig3C

% Fig 4; S5 Fig; S10 Figs
aLB_test_Fig4
