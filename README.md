# fuseMLR-paper

Code to reproduce results in simulation and case study presented in paper "fuseMLR: An R package for integrative prediction modeling of multi-omics data".

## Simulation
Follow the steps below to reproduce the results presented in the simulation section.

## Case study
To reproduce the case study results, perform the following steps.

0 - Use `https://github.com/imbs-hl/fuseMLR-paper.git` to clone this repository or download and save it on your local computer.

1 - Ensure the required packages are installed and load them from `init-global.R`. Also, set up necessary paths.

2 - Use `down_data.R` to download data.

3 - Use `analysis.R` to perform the late integration prediction modeling.

4 - Use `sex-chr-check.R` to get the number of markers sampled from the X and Y chromosomes for each data-modality.
