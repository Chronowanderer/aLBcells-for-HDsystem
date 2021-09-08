# aLBcells-for-HDsystem
Codes (v1.1) in MATLAB 2017a for 

    Yan, Burgess, & Bicanski. (in press). A model of head direction and landmark coding in complex environments. PLOS Computational Biology.

Cite the paper for using codes. Codes provided with no warranty.

## What is the model

The model raises a new type of neuron, abstract landmark bearing (aLB) cells, which endows the animal head direction (HD) system with powerful abilities, including unimodal landmark encoding at a sensory level despite partially conflicting cues, robustness against unreliable and ephemeral cues, and a high encoding capacity across environments. The model is consistent with numerous empirical findings, and provides a novel perspective on the neural mechanisms of spatial navigation in more realistic, cue-rich settings across multiple environments. 

## How to run models
Download Matlab scripts and run each main code section by section, following instructions embedded. These sections include basic settings, hyperparameter settings, data pre-processing, training, basic plotting, and testing (with final plotting).

Four independent main codes are provided:

    aLB_main % aLB_main.m, Simulations of model with a single Visual-aLB connection (Figs 1-4; S1-S5, S8, S10 Figs).
    aLB2HD_main % aLB2HD_main.m, Simulations of model with the whole Visual-aLB-dRSC-HD/gRSC architecture in Fig 1A (Figs 5-8; S6-S8 Figs).
    aLBexcluded_main % aLBexcluded_main.m, Simulations of model with the alternative Visual-dRSC-HD/gRSC architecture without aLB cells (Figs 7-8).
    aLB_main_FigS9 & aLB_main_FigS9.m, Simulations of model with high capacity across multiple rich environments (S9, S11, S12 Figs).

Follow the corresponding instructions to change hyperparameters and settings for different simulations. With testing scripts you would see how the model with aLB cells provides various powerful abilities, such as:

    aLB_test_Fig2 % aLB_test_Fig2.m, Unimodal landmark encoding of complex scenery with directioinally ambiguous cues (Fig 2).
    aLB_test_Fig3AB % aLB_test_Fig3AB.m, Robustness against unreliable cues (Fig 3A-B).
    aLB_test_Fig3C % aLB_test_Fig3C.m, Novel ephemeral salient cue incorporation (Fig 3C, S3-S4 Figs).
    aLB_test_Fig4 % aLB_test_Fig4.m, High encoding capacity across multiple environmnets (Fig 4, S5, S10 Figs).
    aLB_test_FigS9 % aLB_test_FigS9.m, High encoding capacity across multiple rich environmnets (S9, S11, S12 Figs).
    aLB_test_plot % aLB_test_plot.m, Simple plots of aLB representations with various learning algorithms (S1 Fig).
    aLB_test_snapshots % aLB_test_snapshots.m, aLB representations with weights snapshots at different timepoints within the simulation of Fig 2 (S2 Fig).
    aLB2HD_test_Fig5_6B % aLB2HD_test_Fig5_6B.m, Multimodal dRSC units in accordance with previous experimental findings (Fig 5, S6A-D Figs, S6F Fig).
    aLB2HD_test_Fig6A % aLB2HD_test_Fig6A.m, Drifted HD signals in the darkness (Fig 6A).
    aLB2HD_test_Fig5_6B % aLB2HD_test_Fig5_6B.m, Globally stabilized HD signals (Fig 6B).
    aLB2HD_test_Fig7 % aLB2HD_test_Fig7.m, HD rotation following panoramic view against conflicting salient cues with aLB cells (Fig 7B).
    aLB2HD_test_Fig8 % aLB2HD_test_Fig8.m, Reliable HD retrieval across multiple environmnets with aLB cells (Fig 8, left).
    aLB2HD_test_FigS6E % aLB2HD_test_FigS6E.m, Cells during testing phase in the darkness (S6E Fig).
    aLB2HD_test_FigS7 % aLB2HD_test_FigS7.m, Cells during testing phase in the three-environment settings (S7 Fig).
    aLBexcluded_test_Fig7 % aLBexcluded_test_Fig7.m, HD rotation following individual salient conflicting cue without aLB cells (Fig 7C).
    aLBexcluded_test_Fig8 % aLBexcluded_test_Fig8.m, Unreliable HD retrieval across multiple environmnets without aLB cells (Fig 8, right).
    aLB_aLB2HD_FigS8 % aLB_aLB2HD_FigS8.m, Basic plots of generalization, tested in Figs 2 and 7 for all 3 independent HD trajectory data (S8 Fig).

Notice some simulations require modifying in other Matlab scripts. These include:

    Visual_inputs % Visual_inputs.m, Basic visual input formation as visual cell activities.
    Visual_inputs_FigS9 % Visual_inputs_FigS9.m, Basic visual input formation in S9 Fig as visual cell activities.
    aLB_simulation % aLB_simulation.m, Training simulation of model with a single Visual-aLB connection (aLB_main.m). Change learning rules here for S1 Fig.
    
Please strictly follow the corresponding instructions, including returning to the default settings after simulation.

If you want to skip the time-consuming training phase or reduplicate simulation results in the paper, please download MAT files from [Kaggle](https://kaggle.com/chronowanderer/albcells-for-hdsystem-simulation-results), copy the 'Parameters' folder to the 'aLBcells-for-HDsystem' folder that contains codes, load them as training simulation results and only run the testing section in main codes. S8 Fig is plotted from aLB_aLB2HD_FigS8.m in this way.

## What are the files
Figs folder: Figures plotted in the paper based on simulation results provided above.

RealData_CIRC_Manson folder: MATLAB extension files with 3 independent HD trajectory data from the 20-minute real-time rat recording used for simulations. Also provided as supporting information in the paper. Figs 1-8, S1-S7 Figs, and S9-S12 Figs show simulation results based on the data only with Subject 1. S8 Fig shows simulation results based on the data with all 3 subjects. We thank Daniel Manson for providing this real HD trajectory data.

Matlab scripts: See the starting comments of each file for details.

## Contact me
Feel free to contact for any assistance and communication.

Yijia (Charlie) Yan

yijia.yan@ndcn.ox.ac.uk / yijia.yan.18@ucl.ac.uk


Dr. Andrej Bicanski

andrej.bicanski@newcastle.ac.uk / a.bicanski@ucl.ac.uk
