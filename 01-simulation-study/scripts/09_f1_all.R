###############################################
############ Plots
#############################################

# Read data
## Brier score
read_sim_pred(result_wmean_dir, pattern_imp = "f1" , pattern_exp = "f1_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "f1" , pattern_exp = "f1_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "f1" , pattern_exp = "f1_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "f1" , pattern_exp = "f1_blockForest")


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

# F1 and AUC
all_pred <- ls(pattern = "^Sz")

# Read the time performance
create_time(scenario_names = grep("pred", all_pred, value = TRUE))
all_pred_time <- ls(pattern = "_time_")

# Scenario - Me: Effect only in Methylation. 

# F1
sc3_1_name_f1 <- grep("Sz3_20_0_0.*f1", all_pred, value = TRUE)
sc3_1_list_f1 = mget(sc3_1_name_f1)


last_cols_df_me <- lapply(sc3_1_list_f1, function(df) df[ncol(df)])
f1_me <- do.call(what = "cbind", args = last_cols_df_me)
names(f1_me) <- sub(".*_(\\w+)$", "\\1", names(sc3_1_list_f1))
names(f1_me)[names(f1_me) == "blockForest"] <- "BF"
names(f1_me)[names(f1_me) == "lasso"] <- "Lasso"
names(f1_me)[names(f1_me) == "rf"] <- "RF"
names(f1_me)[names(f1_me) == "wm"] <- "WM"
f1_me$Scenario <- "Me"

# Scenario - MeGe: Protein abundance has no effect.
# 20_20_0 

# F1
sc2_3_name_f1 <- grep("Sz2_20_20_0.*f1", all_pred, value = TRUE)
sc2_3_list_f1 = mget(sc2_3_name_f1)


last_cols_me <- lapply(sc2_3_list_f1, function(df) df[ncol(df)])
f1_mege <- do.call(what = "cbind", args = last_cols_me)
names(f1_mege) <- sub(".*_(\\w+)$", "\\1", names(sc2_3_list_f1))
names(f1_mege)[names(f1_mege) == "blockForest"] <- "BF"
names(f1_mege)[names(f1_mege) == "lasso"] <- "Lasso"
names(f1_mege)[names(f1_mege) == "rf"] <- "RF"
names(f1_mege)[names(f1_mege) == "wm"] <- "WM"
f1_mege$Scenario <- "MeGe"

# Scenario - MeGePro: Effect in methylation, gene expression and protein
# abundance
# 20_20_0 

# F1
sc4_name_f1 <- grep("Sz4.*f1", all_pred, value = TRUE)
sc4_list_f1 = mget(sc4_name_f1)


last_cols_megepro <- lapply(sc4_list_f1, function(df) df[ncol(df)])
f1_megepro <- do.call(what = "cbind", args = last_cols_megepro)
names(f1_megepro) <- sub(".*_(\\w+)$", "\\1", names(sc4_list_f1))
names(f1_megepro)[names(f1_megepro) == "blockForest"] <- "BF"
names(f1_megepro)[names(f1_megepro) == "lasso"] <- "Lasso"
names(f1_megepro)[names(f1_megepro) == "rf"] <- "RF"
names(f1_megepro)[names(f1_megepro) == "wm"] <- "WM"
f1_megepro$Scenario <- "MeGePro"


f1_all <- data.table::rbindlist(list(f1_me, f1_mege, f1_megepro))
f1_all_molten <- reshape2::melt(data = f1_all,
                                id.vars = "Scenario",
                                value.name = "f1",
                                variable.name = "Learner")
f1_all_molten$Learner <- factor(x = f1_all_molten$Learner, 
                                levels = c("WM", "Lasso", "RF", "BF"))


# Plot results
f1_all_plots <- ggplot(data = f1_all_molten,
                       mapping = aes(x = Learner,
                                     y = f1,
                                     colour = Learner)) +
  geom_boxplot() +
  ylab("F score") +
  xlab("Learner") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "none",
        legend.direction = "horizontal") +
  guides(color = guide_legend(nrow = 3)) +
  # scale_x_discrete(limits = unique(all_res$Modality),
  #                  labels = c("CNV.RF", "miRNA.SVM", "mRNA.SVM", "Mutation.RF", "Meta.LASSO")) +
  facet_wrap(~ Scenario, ncol = 2)

ggsave(filename = file.path(img_dir, "f1.pdf"),
       plot = f1_all_plots,
       width = 5, height = 5)
