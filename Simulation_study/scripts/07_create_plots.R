###############################################
############ Plots
#############################################

# read data
##brier score
read_sim_pred(result_wmean_dir, pattern_imp = "bs" , pattern_exp = "bs_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "bs" , pattern_exp = "bs_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "bs" , pattern_exp = "bs_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "bs" , pattern_exp = "bs_blockForest")


# auc value
read_sim_pred(result_wmean_dir, pattern_imp = "auc" , pattern_exp = "auc_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "auc" , pattern_exp = "auc_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "auc" , pattern_exp = "auc_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "auc" , pattern_exp = "auc_blockForest")

# time
read_sim_pred(result_wmean_dir, pattern_imp = "pred" , pattern_exp = "pred_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "pred" , pattern_exp = "pred_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "pred" , pattern_exp = "pred_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "pred" , pattern_exp = "pred_blockForest")

# bs and auc
all_pred <- ls(pattern = "^Sz")

# read the time performance
create_time(scenario_names = grep("pred", all_pred, value = TRUE))
all_pred_time <- ls(pattern = "_time_")


# Scenario : One omics modality has no effect.
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

# Time
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

# Time
sc4_name_time <- grep("Sz4", all_pred_time, value = TRUE)
sc4_list_time = mget(sc4_name_time)
create_boxplot_time(scenario_list = sc4_list_time, scenario_names = sc4_name_time,
                   output_folder = img_dir,
                   name = "Sz4_20_20_20_time.pdf")



