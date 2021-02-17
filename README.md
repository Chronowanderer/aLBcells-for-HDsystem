# aLBcells-for-HDsystem
Codes in MATLAB 2017a for Yan, Burgess, & Bicanski, A model of head direction and landmark coding in complex environments, PLOS Computational Biology, Under review.

Codes provided with no warranty.

## How to run models

Download Matlab scripts and run each main code section by section, following instructions embedded.

These sections include basic settings, hyperparameter settings, data pre-processing, training, basic plotting, and testing (with final plotting).

Four independent main codes are provided:

    aLB_main.m - Simulations of model with a single Visual-aLB connection (refer to Figs 1-4, S1-S5 Figs).
    
    aLB2HD_main.m - Simulations of model with the whole Visual-aLB-dRSC-HD/gRSC architecture in Fig 1A (refer to Figs 5-8, S6-S7 Figs).
    
    aLBexcluded_main.m - Simulations of model with the alternative Visual-dRSC-HD/gRSC architecture without aLB cells (refer to Figs 7-8).
    
    aLB_aLB2HD_FigS8.m - Simulations of model from aLB_main.m and aLB2HD_main.m across 3 subjects (refer to S8 Fig).
    
Follow the corresponding instructions to change hyperparameters and settings for different simulations.

Notice some simulations require modifying in other Matlab scripts. These include:

    Visual_inputs.m - Basic visual input formation as visual cell activities.
    
    aLB_simulation.m - Training simulation of model with a single Visual-aLB connection (aLB_main.m). Change learning rules here for S1A Fig.
    
Please strictly follow the corresponding instructions, including returning to the default settings after simulation.

If you want to skip the time-consuming training phase or reduplicate simulation results in the paper, please download MAT files from [Kaggle](https://kaggle.com/chronowanderer/albcells-for-hdsystem-simulation-results), load them as training simulation results, and only run the testing section in main codes.

## What are the files

Figs folder: Figures plotted in the paper based on simulation results provided above.

RealData_CIRC_Manson folder: MATLAB extension files with 3 independent HD trajectory data from the 20-minute real-time rat recording used for simulations. Figs 1-8 and S1-S7 Figs show simulation results based on the data only with Subject 1. S8 Fig shows simulation results based on the data with all 3 subjects.

Matlab scripts: See the starting comments of each file for details.

## Contact me

Feel free to contact me for any assistance and communication.


Yijia (Charlie) Yan

yijia.yan@new.ox.ac.uk
