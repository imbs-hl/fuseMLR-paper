###############################################
############ Plots
#############################################

# Read data

# AUC value
read_sim_pred(result_wmean_dir, pattern_imp = "auc" , pattern_exp = "auc_wm")
read_sim_pred(result_lasso_dir, pattern_imp = "auc" , pattern_exp = "auc_lasso")
read_sim_pred(result_rf_dir, pattern_imp = "auc" , pattern_exp = "auc_rf")
read_sim_pred(result_blockForest_dir, pattern_imp = "auc" , pattern_exp = "auc_blockForest")

# Scenario - Me: Effect only in Methylation. 

# AUC
sc3_1_name_auc <- grep("Sz3_20_0_0.*auc", all_pred, value = TRUE)
sc3_1_list_auc = mget(sc3_1_name_auc)


last_cols_df_me <- lapply(sc3_1_list_auc, function(df) df[ncol(df)])
auc_me <- do.call(what = "cbind", args = last_cols_df_me)
names(auc_me) <- sub(".*_(\\w+)$", "\\1", names(sc3_1_list_auc))
names(auc_me)[names(auc_me) == "blockForest"] <- "BF"
names(auc_me)[names(auc_me) == "lasso"] <- "Lasso"
names(auc_me)[names(auc_me) == "rf"] <- "RF"
names(auc_me)[names(auc_me) == "wm"] <- "WM"
auc_me$Scenario <- "Me"

# Scenario - MeGe: Protein abundance has no effect.
# 20_20_0 

# AUC
sc2_3_name_auc <- grep("Sz2_20_20_0.*auc", all_pred, value = TRUE)
sc2_3_list_auc = mget(sc2_3_name_auc)


last_cols_me <- lapply(sc2_3_list_auc, function(df) df[ncol(df)])
auc_mege <- do.call(what = "cbind", args = last_cols_me)
names(auc_mege) <- sub(".*_(\\w+)$", "\\1", names(sc2_3_list_auc))
names(auc_mege)[names(auc_mege) == "blockForest"] <- "BF"
names(auc_mege)[names(auc_mege) == "lasso"] <- "Lasso"
names(auc_mege)[names(auc_mege) == "rf"] <- "RF"
names(auc_mege)[names(auc_mege) == "wm"] <- "WM"
auc_mege$Scenario <- "MeGe"

# Scenario - MeGePro: Effect in methylation, gene expression and protein
# abundance
# 20_20_0 

# AUC
sc4_name_auc <- grep("Sz4.*auc", all_pred, value = TRUE)
sc4_list_auc = mget(sc4_name_auc)


last_cols_megepro <- lapply(sc4_list_auc, function(df) df[ncol(df)])
auc_megepro <- do.call(what = "cbind", args = last_cols_megepro)
names(auc_megepro) <- sub(".*_(\\w+)$", "\\1", names(sc4_list_auc))
names(auc_megepro)[names(auc_megepro) == "blockForest"] <- "BF"
names(auc_megepro)[names(auc_megepro) == "lasso"] <- "Lasso"
names(auc_megepro)[names(auc_megepro) == "rf"] <- "RF"
names(auc_megepro)[names(auc_megepro) == "wm"] <- "WM"
auc_megepro$Scenario <- "MeGePro"


auc_all <- data.table::rbindlist(list(auc_me, auc_mege, auc_megepro))
auc_all_molten <- reshape2::melt(data = auc_all,
                                id.vars = "Scenario",
                                value.name = "auc",
                                variable.name = "Learner")
auc_all_molten$Learner <- factor(x = auc_all_molten$Learner, 
                                levels = c("WM", "Lasso", "RF", "BF"))


# Plot results
auc_all_plots <- ggplot(data = auc_all_molten,
                       mapping = aes(x = Learner,
                                     y = auc,
                                     colour = Learner)) +
  geom_boxplot() +
  ylab("AUC") +
  xlab("Learner") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        legend.position = "none",
        legend.direction = "horizontal") +
  guides(color = guide_legend(nrow = 3)) +
  # scale_x_discrete(limits = unique(all_res$Modality),
  #                  labels = c("CNV.RF", "miRNA.SVM", "mRNA.SVM", "Mutation.RF", "Meta.LASSO")) +
  facet_wrap(~ Scenario, ncol = 2)

ggsave(filename = file.path(img_dir, "auc.pdf"),
       plot = auc_all_plots,
       width = 5, height = 5)
