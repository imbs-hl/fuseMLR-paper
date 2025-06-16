###############################################
############ Plots
#############################################

# Read data
## Brier score
read_sim_pred(result_wmean_dir, pattern_imp = "bs" , pattern_exp = "bs_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "bs" , pattern_exp = "bs_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "bs" , pattern_exp = "bs_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "bs" , pattern_exp = "bs_blockForest")


# AUC value
read_sim_pred(result_wmean_dir, pattern_imp = "auc" , pattern_exp = "auc_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "auc" , pattern_exp = "auc_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "auc" , pattern_exp = "auc_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "auc" , pattern_exp = "auc_blockForest")

# F1 score value
read_sim_pred(result_wmean_dir, pattern_imp = "f1" , pattern_exp = "f1_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "f1" , pattern_exp = "f1_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "f1" , pattern_exp = "f1_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "f1" , pattern_exp = "f1_blockForest")


# Runtime
read_sim_pred(result_wmean_dir, pattern_imp = "pred" , pattern_exp = "pred_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "pred" , pattern_exp = "pred_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "pred" , pattern_exp = "pred_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "pred" , pattern_exp = "pred_blockForest")

# BS and AUC
all_pred <- ls(pattern = "^Sz")

# Read the time performance
create_time(scenario_names = grep("pred", all_pred, value = TRUE))
all_pred_time <- ls(pattern = "_time_")


# Scenario : Protein abundance has no effect.
# 20_20_0 

# BS
sc2_3_name_bs <- grep("Sz2_20_20_0.*bs", all_pred, value = TRUE)
sc2_3_list_bs = mget(sc2_3_name_bs)
create_boxplots(scenario_list = sc2_3_list_bs, scenario_names = sc2_3_name_bs,
                     output_folder = img_dir,
                     name = "Sz2_20_20_0_bs.pdf")

# AUC
sc2_3_name_auc <- grep("Sz2_20_20_0.*auc", all_pred, value = TRUE)
sc2_3_list_auc = mget(sc2_3_name_auc)
create_boxplot_auc(scenario_list = sc2_3_list_auc, scenario_names = sc2_3_name_auc,
                output_folder = img_dir,
                name = "Sz2_20_20_0_auc.pdf")

# F1 score
sc2_3_name_f1 <- grep("Sz2_20_20_0.*f1", all_pred, value = TRUE)
sc2_3_list_f1 = mget(sc2_3_name_f1)
create_boxplot_f1(scenario_list = sc2_3_list_f1,
                  scenario_names = sc2_3_name_f1,
                   output_folder = img_dir,
                   name = "Sz2_20_20_0_f1.pdf")

# Runtime
sc2_3_name_time <- grep("Sz2_20_20_0", all_pred_time, value = TRUE)
sc2_3_list_time = mget(sc2_3_name_time)
create_boxplot_time(scenario_list = sc2_3_list_time, scenario_names = sc2_3_name_time,
                   output_folder = img_dir,
                   name = "Sz2_20_20_0_time.pdf")


# Scenario 3: Only one omics modality has an effect.
# 20_0_0 

# BS
sc3_1_name_bs <- grep("Sz3_20_0_0.*bs", all_pred, value = TRUE)
sc3_1_list_bs = mget(sc3_1_name_bs)
create_boxplots(scenario_list = sc3_1_list_bs, scenario_names = sc3_1_name_bs,
                     output_folder = img_dir,
                     name = "Sz3_20_0_0_bs.pdf")
# AUC
sc3_1_name_auc <- grep("Sz3_20_0_0.*auc", all_pred, value = TRUE)
sc3_1_list_auc = mget(sc3_1_name_auc)
create_boxplot_auc(scenario_list = sc3_1_list_auc, scenario_names = sc3_1_name_auc,
                output_folder = img_dir,
                name = "Sz3_20_0_0_auc.pdf")

# F1 score
sc3_1_name_f1 <- grep("Sz3_20_0_0.*f1", all_pred, value = TRUE)
sc3_1_list_f1 = mget(sc3_1_name_f1)
create_boxplot_f1(scenario_list = sc3_1_list_f1, scenario_names = sc3_1_name_f1,
                   output_folder = img_dir,
                   name = "Sz3_20_0_0_f1.pdf")

# Time
sc3_1_name_time <- grep("Sz3_20_0_0", all_pred_time, value = TRUE)
sc3_1_list_time = mget(sc3_1_name_time)
create_boxplot_time(scenario_list = sc3_1_list_time, scenario_names = sc3_1_name_time,
                   output_folder = img_dir,
                   name = "Sz3_20_0_0_time.pdf")



# Scenario : Independent effect in all three omics modalities.
#  20_20_20

# BS
sc4_name_bs <- grep("Sz4.*bs", all_pred, value = TRUE)
sc4_list_bs = mget(sc4_name_bs)
create_boxplots(scenario_list = sc4_list_bs, scenario_names = sc4_name_bs,
                     output_folder = img_dir,
                     name = "Sz4_20_20_20_bs.pdf")

# AUC
sc4_name_auc <- grep("Sz4.*auc", all_pred, value = TRUE)
sc4_list_auc = mget(sc4_name_auc)
create_boxplot_auc(scenario_list = sc4_list_auc, scenario_names = sc4_name_auc,
                output_folder = img_dir,
                name = "Sz4_20_20_20_auc.pdf")

# F1 score
sc4_name_f1 <- grep("Sz4.*auc", all_pred, value = TRUE)
sc4_list_f1 = mget(sc4_name_f1)
create_boxplot_f1(scenario_list = sc4_list_f1, scenario_names = sc4_name_f1,
                   output_folder = img_dir,
                   name = "Sz4_20_20_20_f1.pdf")

# Runtime
sc4_name_time <- grep("Sz4", all_pred_time, value = TRUE)
sc4_list_time = mget(sc4_name_time)
create_boxplot_time(scenario_list = sc4_list_time, scenario_names = sc4_name_time,
                   output_folder = img_dir,
                   name = "Sz4_20_20_20_time.pdf")



