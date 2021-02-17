% Main code for vis-HD model without aLB cells (Figs 7-right, 8-right in the paper).

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
Operation_Runenschrift = 1; % Stable HD weights based on optimization (see Zhang, 1996)
Operation_Ratatoskr = 0; % 'Quite' perfect HD weights
Operation_Cyaegha = 0; % random initial HD in each env.
Operation_Midgard = 0; % Containing preinhibition and exclude weights normalisation (mOSA)
    Diabolic_coefficient = 0; % Relative strenth of feedback v.s. feedforward projection in mOSA 
Operation_Sheriruth = 0; % 0 for one-time learning and 1 for repeated learning 
    Plagmatism_time = 10; % Staying duration for repeated learning (s) 10

%% Simulation settings

% selecting HD trajectory data
file = dir('RealData_CIRC_Manson/RealData_CIRC_Manson*.mat');
subject = 1;
Data = load(['RealData_CIRC_Manson/', file(subject).name]);

% parameters file setting
save_data = 'Parameters/Fig_7C';

% default parameters loading
Default_parameters % Change the following parameters for different simulations in the paper

% number of environments
N_env = 2; % Fig 7
% N_env = 10; % Fig 8

% number of cue features
N_cue = 2; % Fig 7
% N_cue = 3; % Fig 8

% Number of visual input layer unit
N_input = N_cue * N_bin;

% Time point (s) for shifting cues
time_CueShifting = beginning + (time / N_env) : (time / N_env) : time;

% angular position (deg) of the center of cues (centralized at initial HD trajectory)
% Environmental dimension: N_env * N_cue

    % Fig 7
    Cue_Init = [0 0; 120 120;]; 
    Strength_Init = ones(N_env, N_cue);
    
    % Fig 8 (please uncomment Line 10 in Visual_inputs.m)
%     Cue_Init = cat(2, ones(N_env, N_cue - 1) .* zeros(1, N_cue - 1), 0 + (-180 : (360 / N_env) : (180 - 360 / N_env))');
%     Strength_Init = ones(N_env, N_cue);

% global cue settings
Cue_global = Cue_Init;
Strength_global = Strength_Init;

% minimun firing rate (scaled) for enabling to encode the abstract representation 
firingrate_criterion = .5; % will later plot all aLB cells if no one exceeds the threshold

%% adding/modifyingg parameters specific to vis-HD model without aLB cells
U_vis2dRSC_gain_factor = 3; % 30 for Operation_Midgard = 1
U_g2dRSC_gain_factor = 3;
U_dRSC2dRSC_gain_factor = 100; % 400 for Operation_Midgard = 1
W_vis2dRSC_weight_scale = N_cue;
lr_initial_rate_vis2dRSC = 1e-4;
lr_decay_rate_vis2dRSC = 0; % Hz

%% HD trajectory settings
HD_trajectory

%% Calculating Weights for HD system
HD_attractor_weights

%% Visual input settings
% For Fig 8, choose Line 21 for feature 1 in Visual_inputs.m
% For others, choose Line 20 for feature 1 in Visual_inputs.m
Visual_inputs
F_visual_feature_norm

%% Simulation - training
[X, Y] = meshgrid(Angle, 1 : N_abstract);
hwait = waitbar(0, 'Head Turning Progress 0%');
elapsed_time = 0;
Stopwatch = tic;
aLBexcluded_simulation % Training
close(hwait);

%% Save/load data from training
save(save_data)
% load('Parameters/Fig_7C') % load training results (if saved) to do the test

%% General plotting
% HD_trajectory_plot
% Visual_inputs_plot
HD_progress_plot

%% Simulation - testing
% Note testing plots are simultaneously conducted during the testing phase.
% Run one of them every time, and remember to setup parameters and
% operations before running.

% Figs 7
aLBexcluded_test_Fig7

% Fig 8-reght
% aLBexcluded_test_Fig8

% end
