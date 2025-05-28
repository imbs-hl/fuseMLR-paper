##################################################
#### Performance estimation
#### blockForest
##################################################


# read all predictions
read_sim_pred(src_dir = result_blockForest_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# create brier score
create_bs_early(szenarien_namen = all_pred_namen, suffix = "blockForest", 
          output_folder = result_blockForest_dir)

# create auc
create_auc_early(szenarien_namen = all_pred_namen, suffix = "blockForest", 
           output_folder = result_blockForest_dir)
