##################################################
#### Performance estimation
#### blockForest
##################################################


# Read all predictions
read_sim_pred(src_dir = result_blockForest_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# Create brier score
create_bs_early(szenarien_namen = all_pred_namen, suffix = "blockForest", 
          output_dir = result_blockForest_dir)

# Create auc
create_auc_early(szenarien_namen = all_pred_namen, suffix = "blockForest", 
           output_dir = result_blockForest_dir)

# Create F1 score
create_f1_early(szenarien_namen = all_pred_namen, suffix = "blockForest", 
                 output_dir = result_blockForest_dir)
