###############################################
############ Plots
#############################################

# read data
##brier score
read_sim_pred(result_mean_dir, pattern_imp = "bs" , pattern_exp = "bs_m")
read_sim_pred(result_wmean_dir, pattern_imp = "bs" , pattern_exp = "bs_wm")
read_sim_pred(result_best_dir, pattern_imp = "bs" , pattern_exp = "bs_best")
read_sim_pred(result_cobra_dir, pattern_imp = "bs" , pattern_exp = "bs_cobra_epsilon")
read_sim_pred(result_mia_dir, pattern_imp = "bs" , pattern_exp = "bs_mia")
read_sim_pred(result_lasso_dir, pattern_imp = "bs" , pattern_exp = "bs_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "bs" , pattern_exp = "bs_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "bs" , pattern_exp = "bs_blockForest")


# auc value
read_sim_pred(result_mean_dir, pattern_imp = "auc" , pattern_exp = "auc_m")
read_sim_pred(result_wmean_dir, pattern_imp = "auc" , pattern_exp = "auc_wm")
read_sim_pred(result_best_dir, pattern_imp = "auc" , pattern_exp = "auc_best")
read_sim_pred(result_cobra_dir, pattern_imp = "auc" , pattern_exp = "auc_cobra_epsilon")
read_sim_pred(result_mia_dir, pattern_imp = "auc" , pattern_exp = "auc_mia")
read_sim_pred(result_lasso_dir, pattern_imp = "auc" , pattern_exp = "auc_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "auc" , pattern_exp = "auc_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "auc" , pattern_exp = "auc_blockForest")

# time
read_sim_pred(result_mean_dir, pattern_imp = "pred" , pattern_exp = "pred_m")
read_sim_pred(result_wmean_dir, pattern_imp = "pred" , pattern_exp = "pred_wm")
read_sim_pred(result_best_dir, pattern_imp = "pred" , pattern_exp = "pred_best")
read_sim_pred(result_cobra_dir, pattern_imp = "pred" , pattern_exp = "pred_cobra_epsilon")
read_sim_pred(result_mia_dir, pattern_imp = "pred" , pattern_exp = "pred_mia")
read_sim_pred(result_lasso_dir, pattern_imp = "pred" , pattern_exp = "pred_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "pred" , pattern_exp = "pred_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "pred" , pattern_exp = "pred_blockForest")

# bs and auc
all_pred <- ls(pattern = "^Sz")

# read the time performance
create_time(scenario_names = grep("pred", all_pred, value = TRUE))
all_pred_time <- ls(pattern = "_time_")

# Scenario 1:
# Null model – no effect is present in any of the three omics modalities.


## BS
sc1_name_bs <- grep("Sz1.*bs", all_pred, value = TRUE)
sc1_list_bs = mget(sc1_name_bs)
create_boxplot_nullm(scenario_list = sc1_list_bs, scenario_names = sc1_name_bs,
                           output_folder = img_dir,
                           name = "Sz1_0_0_0_bs.pdf")

## AUC
sc1_name_auc <- grep("Sz1.*auc", all_pred, value = TRUE)
sc1_list_auc = mget(sc1_name_auc)


create_boxplot_nullm_auc(scenario_list = sc1_list_auc, scenario_names = sc1_name_auc,
                     output_folder = img_dir,
                     name = "Sz1_0_0_0_auc.pdf")


## Time
sc1_name_time <- grep("Sz1", all_pred_time, value = TRUE)
sc1_list_time = mget(sc1_name_time)
create_boxplot_time(scenario_list = sc1_list_time, scenario_names = sc1_name_time,
                output_folder = img_dir,
                name = "Sz1_0_0_0_time.pdf")


# Scenario 2: One omics modality has no effect.
#  0_20_20

#BS
sc2_1_name_bs <- grep("Sz2_0_20_20.*bs", all_pred, value = TRUE)
sc2_1_list_bs = mget(sc2_1_name_bs)

create_boxplots(scenario_list = sc2_1_list_bs, scenario_names = sc2_1_name_bs,
                output_folder = img_dir,
                name = "Sz2_0_20_20_bs.pdf")

# AUC
sc2_1_name_auc <- grep("Sz2_0_20_20.*auc", all_pred, value = TRUE)
sc2_1_list_auc = mget(sc2_1_name_auc)

create_boxplot_auc(scenario_list = sc2_1_list_auc, scenario_names = sc2_1_name_auc,
                output_folder = img_dir,
                name = "Sz2_0_20_20_auc.pdf")


# Time
sc2_1_name_time <- grep("Sz2_0_20_20", all_pred_time, value = TRUE)
sc2_1_list_time = mget(sc2_1_name_time)

create_boxplot_time(scenario_list = sc2_1_list_time, scenario_names = sc2_1_name_time,
                   output_folder = img_dir,
                   name = "Sz2_0_20_20_time.pdf")
#  20_0_20 

# BS
sc2_2_name_bs <- grep("Sz2_20_0_20.*bs", all_pred, value = TRUE)
sc2_2_list_bs = mget(sc2_2_name_bs)

create_boxplots(scenario_list = sc2_2_list_bs, scenario_names = sc2_2_name_bs,
                     output_folder = img_dir,
                     name = "Sz2_20_0_20_bs.pdf")

#AUC
sc2_2_name_auc <- grep("Sz2_20_0_20.*auc", all_pred, value = TRUE)
sc2_2_list_auc = mget(sc2_2_name_auc)

create_boxplot_auc(scenario_list = sc2_2_list_auc, scenario_names = sc2_2_name_auc,
                output_folder = img_dir,
                name = "Sz2_20_0_20_auc.pdf")


#Time
sc2_2_name_time <- grep("Sz2_20_0_20", all_pred_time, value = TRUE)
sc2_2_list_time = mget(sc2_2_name_time)

create_boxplot_time(scenario_list = sc2_2_list_time, scenario_names = sc2_2_name_time,
                   output_folder = img_dir,
                   name = "Sz2_20_0_20_time.pdf")
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

# 0_20_0 

# BS
sc3_2_name_bs <- grep("Sz3_0_20_0.*bs", all_pred, value = TRUE)
sc3_2_list_bs = mget(sc3_2_name_bs)
create_boxplots(scenario_list = sc3_2_list_bs, scenario_names = sc3_2_name_bs,
                     output_folder = img_dir,
                     name = "Sz3_0_20_0_bs.pdf")

# AUC
sc3_2_name_auc <- grep("Sz3_0_20_0.*auc", all_pred, value = TRUE)
sc3_2_list_auc = mget(sc3_2_name_auc)
create_boxplot_auc(scenario_list = sc3_2_list_auc, scenario_names = sc3_2_name_auc,
                output_folder = img_dir,
                name = "Sz3_0_20_0_auc.pdf")

# Time
sc3_2_name_time <- grep("Sz3_0_20_0", all_pred_time, value = TRUE)
sc3_2_list_time = mget(sc3_2_name_time)
create_boxplot_time(scenario_list = sc3_2_list_time, scenario_names = sc3_2_name_time,
                   output_folder = img_dir,
                   name = "Sz3_0_20_0_time.pdf")

# 0_0_20

# BS
sc3_3_name_bs <- grep("Sz3_0_0_20.*bs", all_pred, value = TRUE)
sc3_3_list_bs = mget(sc3_3_name_bs)
create_boxplots(scenario_list = sc3_3_list_bs, scenario_names = sc3_3_name_bs,
                     output_folder = img_dir,
                     name = "Sz3_0_0_20_bs.pdf")

# AUC
sc3_3_name_auc <- grep("Sz3_0_0_20.*auc", all_pred, value = TRUE)
sc3_3_list_auc = mget(sc3_3_name_auc)
create_boxplot_auc(scenario_list = sc3_3_list_auc, scenario_names = sc3_3_name_auc,
                output_folder = img_dir,
                name = "Sz3_0_0_20_auc.pdf")

# Time
sc3_3_name_time <- grep("Sz3_0_0_20", all_pred_time, value = TRUE)
sc3_3_list_time = mget(sc3_3_name_time)
create_boxplot_time(scenario_list = sc3_3_list_time, scenario_names = sc3_3_name_time,
                   output_folder = img_dir,
                   name = "Sz3_0_0_20_time.pdf")

# Scenario 4: Independent effect in all three omics modalities.
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

# Scenario 5: Dependent effect across modalities.
# 20_NULL_NULL

#BS
sc5_name_bs <- grep("Sz5.*bs", all_pred, value = TRUE)
sc5_list_bs = mget(sc5_name_bs)
create_boxplots(scenario_list = sc5_list_bs, scenario_names = sc5_name_bs, 
                     output_folder = img_dir,
                     name = "Sz5_20_NULL_NULL_bs.pdf")

# AUC
sc5_name_auc <- grep("Sz5.*auc", all_pred, value = TRUE)
sc5_list_auc = mget(sc5_name_auc)
create_boxplot_auc(scenario_list = sc5_list_auc, scenario_names = sc5_name_auc, 
                output_folder = img_dir,
                name = "Sz5_20_NULL_NULL_auc.pdf")

# Time
sc5_name_time <- grep("Sz5", all_pred_time, value = TRUE)
sc5_list_time = mget(sc5_name_time)
create_boxplot_time(scenario_list = sc5_list_time, scenario_names = sc5_name_time, 
                   output_folder = img_dir,
                   name = "Sz5_20_NULL_NULL_time.pdf")

