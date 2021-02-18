# aLBcells-for-HDsystem
Codes in MATLAB 2017a for 

    Yan, Burgess, & Bicanski. A model of head direction and landmark coding in complex environments. PLOS Computational Biology. Under review.

Cite the paper for using codes. Codes provided with no warranty.

## What is the model

The model raises a new type of neuron (abstract landmark bearing (aLB) cells) which endows the animal head direction (HD) system with powerful abilities, including unimodal landmark encoding at a sensory level despite partially conflicting cues, robustness against unreliable and ephemeral cues, and a high encoding capacity across environments. The model is consistent with numerous empirical findings, and provides a novel perspective on the neural mechanisms of spatial navigation in more realistic, cue-rich settings across multiple environments. 

## How to run models
Download Matlab scripts and run each main code section by section, following instructions embedded. These sections include basic settings, hyperparameter settings, data pre-processing, training, basic plotting, and testing (with final plotting).

Three independent main codes are provided:

    aLB_main.m - Simulations of model with a single Visual-aLB connection (refer to Figs 1-4; S1-S5, S8 Figs),
    aLB2HD_main.m - Simulations of model with the whole Visual-aLB-dRSC-HD/gRSC architecture in Fig 1A (refer to Figs 5-8; S6-S8 Figs), and
    aLBexcluded_main.m - Simulations of model with the alternative Visual-dRSC-HD/gRSC architecture without aLB cells (refer to Figs 7-8).
    
Follow the corresponding instructions to change hyperparameters and settings for different simulations. You would see how the model with aLB cells provides various powerful abilities, such as:

    Unimodal landmark encoding of complex scenery with directioinally ambiguous cues (Fig 2),
    Robustness against unreliable cues (Fig 3A-B),
    Novel ephemeral salient cue incorporation (Fig 3C),
    High encoding capacity across multiple environmnets (Fig 4),
    Multimodal dRSC units in accordance with previous experimental findings (Fig 5),
    Globally stabilized HD signals (Fig 6),
    HD disambiguition with HD rotation following panoramic view against conflicting salient cues (Fig 7), and
    Reliable HD retrieval across multiple environmnets (Fig 8).

Notice some simulations require modifying in other Matlab scripts. These include:

    Visual_inputs.m - Basic visual input formation as visual cell activities, and
    aLB_simulation.m - Training simulation of model with a single Visual-aLB connection (aLB_main.m). Change learning rules here for S1A Fig.
    
Please strictly follow the corresponding instructions, including returning to the default settings after simulation.

If you want to skip the time-consuming training phase or reduplicate simulation results in the paper, please download MAT files from [Kaggle](https://kaggle.com/chronowanderer/albcells-for-hdsystem-simulation-results), load them as training simulation results, and only run the testing section in main codes. S8 Fig is plotted from aLB_aLB2HD_FigS8.m in this way.

## What are the files
Figs folder: Figures plotted in the paper based on simulation results provided above.

RealData_CIRC_Manson folder: MATLAB extension files with 3 independent HD trajectory data from the 20-minute real-time rat recording used for simulations. Also provided as supporting information in the paper. Figs 1-8 and S1-S7 Figs show simulation results based on the data only with Subject 1. S8 Fig shows simulation results based on the data with all 3 subjects. We thank Daniel Manson for providing this real HD trajectory data.

Matlab scripts: See the starting comments of each file for details.

## Contact me
Feel free to contact me for any assistance and communication.

Yijia (Charlie) Yan

yijia.yan@ndcn.ox.ac.uk / yijia.yan.18@ucl.ac.uk
