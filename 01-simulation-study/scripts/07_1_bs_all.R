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

# Scenario - Me: Effect only in Methylation. 

# BS
sc3_1_name_bs <- grep("Sz3_20_0_0.*bs", all_pred, value = TRUE)
sc3_1_list_bs = mget(sc3_1_name_bs)


last_cols_df_me <- lapply(sc3_1_list_bs, function(df) df[ncol(df)])
bs_me <- do.call(what = "cbind", args = last_cols_df_me)
names(bs_me) <- sub(".*_(\\w+)$", "\\1", names(sc3_1_list_bs))
names(bs_me)[names(bs_me) == "blockForest"] <- "BF"
names(bs_me)[names(bs_me) == "lasso"] <- "Lasso"
names(bs_me)[names(bs_me) == "rf"] <- "RF"
names(bs_me)[names(bs_me) == "wm"] <- "WM"
bs_me$Scenario <- "Me"

# Scenario - MeGe: Protein abundance has no effect.
# 20_20_0 

# BS
sc2_3_name_bs <- grep("Sz2_20_20_0.*bs", all_pred, value = TRUE)
sc2_3_list_bs = mget(sc2_3_name_bs)


last_cols_me <- lapply(sc2_3_list_bs, function(df) df[ncol(df)])
bs_mege <- do.call(what = "cbind", args = last_cols_me)
names(bs_mege) <- sub(".*_(\\w+)$", "\\1", names(sc2_3_list_bs))
names(bs_mege)[names(bs_mege) == "blockForest"] <- "BF"
names(bs_mege)[names(bs_mege) == "lasso"] <- "Lasso"
names(bs_mege)[names(bs_mege) == "rf"] <- "RF"
names(bs_mege)[names(bs_mege) == "wm"] <- "WM"
bs_mege$Scenario <- "MeGe"

# Scenario - MeGePro: Effect in methylation, gene expression and protein
# abundance
# 20_20_0 

# BS
sc4_name_bs <- grep("Sz4.*bs", all_pred, value = TRUE)
sc4_list_bs = mget(sc4_name_bs)


last_cols_megepro <- lapply(sc4_list_bs, function(df) df[ncol(df)])
bs_megepro <- do.call(what = "cbind", args = last_cols_megepro)
names(bs_megepro) <- sub(".*_(\\w+)$", "\\1", names(sc4_list_bs))
names(bs_megepro)[names(bs_megepro) == "blockForest"] <- "BF"
names(bs_megepro)[names(bs_megepro) == "lasso"] <- "Lasso"
names(bs_megepro)[names(bs_megepro) == "rf"] <- "RF"
names(bs_megepro)[names(bs_megepro) == "wm"] <- "WM"
bs_megepro$Scenario <- "MeGePro"


bs_all <- data.table::rbindlist(list(bs_me, bs_mege, bs_megepro))
bs_all_molten <- reshape2::melt(data = bs_all,
                                  id.vars = "Scenario",
                                  value.name = "BS",
                                variable.name = "Learner")
bs_all_molten$Learner <- factor(x = bs_all_molten$Learner, 
                          levels = c("WM", "Lasso", "RF", "BF"))


# Plot results
bs_all_plots <- ggplot(data = bs_all_molten,
                    mapping = aes(x = Learner,
                                  y = BS,
                                  colour = Learner)) +
  geom_boxplot() +
  ylab("BS") +
  xlab("Learner") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "none",
        legend.direction = "horizontal") +
  guides(color = guide_legend(nrow = 3)) +
  # scale_x_discrete(limits = unique(all_res$Modality),
  #                  labels = c("CNV.RF", "miRNA.SVM", "mRNA.SVM", "Mutation.RF", "Meta.LASSO")) +
  facet_wrap(~ Scenario, ncol = 3)

ggsave(filename = file.path(img_dir, "bs.pdf"),
       plot = bs_all_plots,
       width = 5, height = 2.5)
