% Default parameters for all models, based on red-blue scenery (Fig 2).

% timing
time = 60 * 20; % Duraion time (s) (Experimental Duration: 20 mins)
beginning = 60 * 0; % Initial time point (s)
stop_learning_time = beginning + time; % End time (s) for learning

% Time interval (s)
dt_exp = 0.02;
if Operation_Noatun
    dt = 0.002;
else
    dt = dt_exp;
end
Time = 0 : dt_exp : time; % Time
T_len = length(Time); % Number of time point

% angular interval (deg)
angle_gap = 1; % Please ensure that the gap of angle could divide 180!
Angle = -180 : angle_gap : (180 - angle_gap); % Preferred direction

% number of units with distinct preferred directions
N_bin = length(Angle);

% number of subsequent environments
N_env = 1;

% number of distinguishable cues
N_cue = 2;

% Number of visual input layer unit
N_input = N_cue * N_bin;

% Number of abstract layer unit
N_abstract = 360;

% angular position (deg) of the center of cues (centralized at initial HD trajectory)
% Environmental dimension: N_env * N_cue
Cue_Init = ones(N_env, N_cue) * 360 - 360;
Strength_Init = ones(N_env, N_cue);
Cue_global = Cue_Init;
Strength_global = Strength_Init;

% interinhibition matrix of abstract representation
Inhibition_U_arep = (ones(N_abstract) - eye(N_abstract)) / sqrt(N_abstract - 1); % lateral inhibition
% Inhibition_U_arep = ones(N_abstract) / sqrt(N_abstract); % global inhibition
% Inhibition_U_arep = zeros(N_abstract); % no inhibition

% artificial HD velocity (deg/s)
vlcty_tuning = 100;

% Time point (s) for shifting cues
time_CueShifting = beginning + (time / N_env) : (time / N_env) : time;

% Membrane Potential Time (s) & Decay Rate
time_constant_arep = 0.02;
decay_rate_arep = dt / time_constant_arep;
time_constant_dRSC = 0.02;
decay_rate_dRSC = dt / time_constant_dRSC;
time_constant_gRSC = 0.02;
decay_rate_gRSC = dt / time_constant_gRSC;
time_constant_HD = 0.02;
decay_rate_HD = dt / time_constant_HD;

time_constant_vSTM = 0.5;
decay_rate_vSTM = dt / time_constant_vSTM;
time_constant_interval = 1;
decay_rate_interval = dt / time_constant_interval;

% activation function
alpha_arep = 0;
beta_arep = 0.05;
gamma_arep = 0;
alpha_dRSC = 0;
beta_dRSC = 0.04;
gamma_dRSC = 0;
alpha_gRSC = 0;
beta_gRSC = 0.04;
gamma_gRSC = 0;
alpha_HD = 20;
beta_HD = 0.08;
gamma_HD = 0;

% learing rate
lr_initial_rate_visual = 1e-3;
lr_decay_rate_visual = 0; % Hz
dr_weight_visual = 0; 
lr_initial_rate_arep2dRSC = 1e-4;
lr_decay_rate_arep2dRSC = 0; % Hz
lr_initial_rate_g2dRSC = 5e-5; 
lr_decay_rate_g2dRSC = 0; % Hz

lr_initial_rate_arep2dRSC_slow = lr_initial_rate_arep2dRSC; 
lr_decay_rate_arep2dRSC_slow = lr_decay_rate_arep2dRSC; % Hz
lr_initial_rate_g2dRSC_slow = lr_initial_rate_g2dRSC; 
lr_decay_rate_g2dRSC_slow = lr_decay_rate_g2dRSC; % Hz

% angular length of proximal cue
proximal_length = 180;

% vonmises encoding precision: FWHM =~ 60/45/30/20/10 when precision =~ 5/9/20/45/180
precision_visual1 = 20;
precision_visual2 = 80;
precision_HD = 15;
precision_sub = 1;
precision_visualfield = 1;

% gain factors
inhibition_U_arep = 500;
Uv_gain_factor = 2;
U_arep2dRSC_gain_factor = 50;
U_g2dRSC_gain_factor = 5;
U_dRSC2dRSC_gain_factor = 50; 
U_gRSC2gRSC_gain_factor = 50; 
U_HD2gRSC_gain_factor = 50; 
U_HD_gain_factor = 1; 
U_dRSC2HD_gain_factor = 0.1; 
U_dRSC2HD_i_gain_factor = 2; 
U_gRSC2HD_gain_factor = 0; 
Wv_weight_scale = 10; 
W_arep2dRSC_weight_scale = 1; 
W_g2dRSC_weight_scale = 1; 
W_dRSC2HD_weight_scale = 1; 

% the maximum of visual firing rate
Fv_max_factor = 1.0; 

% minimun firing rate (scaled) for enabling to encode
firingrate_criterion = .5; % will later plot all cells if no one exceeds the threshold

% visual noise intensity
visual_noise_intensity = 0;

% theta wave for encoding (ff: feedforward) & retrieving (fb: feedback)
theta_intensity_ff = 0; % [0, 1]
theta_intensity_fb = 0;
theta_frequency_ff = 5; % Hz
theta_frequency_fb = 5;
theta_phase_ff = 0; % deg
theta_phase_fb = 180;

% Total resource of visual featural attention to abstract layer
total_featural_attention = N_cue;

% anticipatory time interval (s)
rho = 0; % 0.025
% regularization for weight
lambda = 1;
% stable weights with noise or bias
Operation_Ratatoskr = 0;
weight_bias = Operation_Ratatoskr * 0;
weight_noise_scale = Operation_Ratatoskr * 0.0005;
asyweightstrength_noise_scale = Operation_Ratatoskr * 0; % the noise of asymmetric weight strength
% parameters for initial HD activity level
angluarrepresentation_phase = 0; % deg
noise_scale = 0;

% plotting settings
row = 2;
column = 3;
Black_White = [.9 .6 .3 0];
Color = [1 0 0;
         0 0 1;
         0 1 0;
         1 0 1;
         0 1 1;
         1 1 0;];
OrdinalNum = ['st'; 'nd'; 'rd'; 'th'];
time_duration_around = 10; % Time duration around changing time (s)
max_selection = 4; % preparing for showing abstract representation
