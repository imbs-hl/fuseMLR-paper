source("init.R")

# Create data modalities
source(file.path(script_dir, "01_simulate_data.R"))
source(file.path(script_dir, "02_1_prepare_sim_data.R"))
source(file.path(script_dir, "02_2_prepare_sim_data_early.R"))

# Predict probabilities for each approaches
source(file.path(script_dir, "03_1_create_pred_wmean.R"))
source(file.path(script_dir, "04_1_create_pred_lasso.R"))
source(file.path(script_dir, "05_1_create_pred_blockForest_early.R"))
source(file.path(script_dir, "06_1_create_pred_rf_early.R"))

# Estimate performance for each approaches
source(file.path(script_dir, "03_2_create_perform_wmean.R"))
source(file.path(script_dir, "04_2_create_perform_lasso.R"))
source(file.path(script_dir, "05_2_create_perform_blockForest_early.R"))
source(file.path(script_dir, "06_2_create_perform_rf_early.R"))

# Resume results
source(file.path(script_dir, "07_1_bs_all.R"))
source(file.path(script_dir, "07_2_f1_all.R"))
source(file.path(script_dir, "07_3_auc_all.R"))