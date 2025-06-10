# fuseMLR-paper

Code to reproduce results in simulation and case study presented in paper "fuseMLR: An R package for integrative prediction modeling of multi-omics data".

Use `https://github.com/imbs-hl/fuseMLR-paper.git` to clone this repository or download and save it on your local computer.

## Simulation

To reproduce the simulation study results, move to the directory `Simulation_study`, and perform the following steps.

Each script works on its own and needs to load `init.R` at the start, which
loads all necessary packages and functions and defines paths.

It is recommended to clear the workspace before running each script to avoid 
conflicts between objects.

The analysis follows a structured approach. First, multi-omics data—including methylation, gene expression, and protein abundance—are simulated for each scenario. We consider three scenarios based on the distribution of effects across data modalities: one with effects only in methylation, one with effects in both methylation and gene expression, and one with effects in all three modalities. We prepare data depending on the integration strategy — either late integration (fuseMLR) or early integration (Random Forest and blockForest). For each integration strategy, we train and assess the corresponding model.

Running the following scripts reproduces the results as presented in the article.

`init.R`- This file is located in the directory `Simulation_study`. It loads all required libraries, defines file paths, and sources functions. This file must be sourced at the beginning of each script.

The following files are located in `scripts`.

`01_simulate_data.R` - Simulates various scenarios and stores the output in data/InterSIM/.

`02_1_prepare_sim_data.R` - Prepares the simulated data for late integration (used by fuseMLR) and saves it in data/InterSIM_split/.

`02_2_prepare_sim_data_early.R` - Prepares the simulated data for early integration (used by blockForest) and saves it in data/InterSIM_split_early/.

`03_1_create_pred_wmean.R` - Trains prediction model using the weighted mean meta-learner.

`03_2_create_perform_wmean.R` - Evaluates the performance of the weighted mean meta-learner.

`04_1_create_pred_lasso.R` - Trains prediction model using Lasso meta-learner.

`04_2_create_perform_lasso.R` - Evaluates the performance of Lasso meta-learner.

`05_1_create_pred_blockForest_early.R` - Trains prediction model using blockForest for early integration.

`05_2_create_perform_blockForest_early.R` - Evaluates the performance of blockForest for early integration.

`06_1_create_pred_rf_early.R` - Trains prediction model using random forest for early integration.

`06_2_create_perform_rf_early.R` - Evaluates the performance of random forest for early integration.

`07_create_plots.R` - Generates plots for visualization of the results. Stores the output in img.

## Case study
To reproduce the case study results, perform the following steps.

1 - Ensure the required packages are installed and load them from `init-global.R`. Also, set up necessary paths.

2 - Use `down_data.R` to download data.

3 - Use `analysis.R` to perform the late integration prediction modeling.

4 - Use `sex-chr-check.R` to get the number of markers sampled from the X and Y chromosomes for each data-modality.
