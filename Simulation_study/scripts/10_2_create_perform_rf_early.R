##################################################
#### Performance estimation
#### Random Forest
##################################################


# read all predictions
read_sim_pred(src_dir = result_rf_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# create brier score
create_bs_early(szenarien_namen = all_pred_namen, suffix = "rf", 
          output_folder = result_rf_dir)

# create auc
create_auc_early(szenarien_namen = all_pred_namen, suffix = "rf", 
           output_folder = result_rf_dir)
