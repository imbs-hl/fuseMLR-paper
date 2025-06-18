##################################################
#### Performance estimation
#### Random Forest
##################################################


# Read all predictions
read_sim_pred(src_dir = result_rf_dir, pattern_imp = "pred", 
              pattern_exp = "pred")

all_pred_namen <- ls(pattern = "^Sz.*pred")


# Create brier score
create_bs_early(szenarien_namen = all_pred_namen, suffix = "rf", 
          output_dir = result_rf_dir)

# Create auc
create_auc_early(szenarien_namen = all_pred_namen, suffix = "rf", 
           output_dir = result_rf_dir)

# Create f1 score
create_f1_early(szenarien_namen = all_pred_namen, suffix = "rf", 
                 output_dir = result_rf_dir)
