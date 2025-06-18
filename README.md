# fuseMLR-paper

Code to reproduce results in the simulation and case study presented in the paper "fuseMLR: An R package for integrative prediction modeling of multi-omics data".

Use `https://github.com/imbs-hl/fuseMLR-paper.git` to clone this repository or download and save it on your local computer.

## Simulation

To reproduce the simulation study results, move to the directory `Simulation_study`, and perform the following steps.

Each script works on its own and needs to load `init.R` at the start, which
loads all necessary packages and functions and defines paths.

It is recommended to clear the workspace before running each script to avoid 
conflicts between objects.

The analysis follows a structured approach. First, multi-omics data—including methylation, gene expression, and protein abundance—are simulated for each scenario. We consider three scenarios based on the distribution of effects across data modalities: one with effects only in methylation, one with effects in both methylation and gene expression, and one with effects in all three modalities. We prepare data depending on the integration strategy — either late integration (fuseMLR) or early integration (Random Forest and blockForest). For each integration strategy, we train and assess the corresponding model.

The following files are located in `scripts`.

1 - Ensure your current directory is `Simulation_study` and run the `init.R` file. The R packages listed in this file need to be installed. If it is not the case, use the instructions mentioned in the file to install the necessary packages. 

2 - Run the script `run_simulation.R`.

3 - Search for results in the `img` subdirectory created in `Simulation_study`.


## Case study
To reproduce the case study results, follow these steps.

1 - Ensure the required packages are installed and load them from `init-global.R`. Also, set up the necessary paths.

2 - Use `down_data.R` to download data.

3 - Use `analysis.R` to perform the late integration prediction modeling.

4 - Use `sex-chr-check.R` to get the number of markers sampled from the X and Y chromosomes for each data-modality.
